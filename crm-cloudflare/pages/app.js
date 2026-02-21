const state = {
  token: localStorage.getItem('crm_token') || null,
  user: null,
  companies: [],
  reps: [],
  currentCompany: null,
  companyContacts: [],
  companyInteractions: [],
  repAssignments: [],
  repTerritories: [],
  companyFilter: '',
  history: []
};

const API_BASE = window.CRM_API_BASE || '';

const VIEW_IDS = [
  'authView',
  'companyListView',
  'companyDetailView',
  'contactDetailView',
  'contactCreateView',
  'interactionDetailView',
  'interactionCreateView',
  'repsView'
];

const els = {
  pageHint: document.getElementById('pageHint'),
  backBtn: document.getElementById('backBtn'),
  manageRepsBtn: document.getElementById('manageRepsBtn'),
  whoami: document.getElementById('whoami'),
  logoutBtn: document.getElementById('logoutBtn'),
  toast: document.getElementById('toast')
};

function canWrite() {
  return ['admin', 'manager', 'rep'].includes(state.user?.role);
}

function canManageReps() {
  return ['admin', 'manager'].includes(state.user?.role);
}

function showToast(message, isError = false) {
  els.toast.textContent = message;
  els.toast.classList.remove('hidden', 'error');
  if (isError) els.toast.classList.add('error');
  setTimeout(() => els.toast.classList.add('hidden'), 2200);
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function setView(viewId, hint, pushHistory = true) {
  if (!VIEW_IDS.includes(viewId)) return;

  const active = VIEW_IDS.find((v) => !document.getElementById(v).classList.contains('hidden'));
  if (pushHistory && active && active !== viewId && active !== 'authView') {
    state.history.push(active);
  }

  VIEW_IDS.forEach((v) => document.getElementById(v).classList.add('hidden'));
  document.getElementById(viewId).classList.remove('hidden');

  els.pageHint.textContent = hint;
  els.backBtn.classList.toggle('hidden', viewId === 'companyListView' || viewId === 'authView');
}

async function api(path, options = {}) {
  const headers = new Headers(options.headers || {});
  if (!headers.has('content-type') && !(options.body instanceof FormData)) {
    headers.set('content-type', 'application/json');
  }
  if (state.token) headers.set('authorization', `Bearer ${state.token}`);

  const response = await fetch(`${API_BASE}${path}`, { ...options, headers });
  let data = null;
  try {
    data = await response.json();
  } catch {
    data = null;
  }

  if (!response.ok) throw new Error(data?.error || `Request failed (${response.status})`);
  return data;
}

async function loadCompanies() {
  const result = await api('/api/companies');
  state.companies = result.companies;
  renderCompanies();
}

async function loadReps() {
  const result = await api('/api/reps');
  state.reps = result.reps;
}

function filteredCompanies() {
  const q = state.companyFilter.trim().toLowerCase();
  if (!q) return state.companies;
  return state.companies.filter((c) => `${c.name || ''} ${c.city || ''} ${c.state || ''}`.toLowerCase().includes(q));
}

function renderCompanies() {
  const rows = filteredCompanies();
  const body = document.getElementById('companiesBody');
  body.innerHTML = rows
    .map(
      (c) => `<tr class="clickable" data-company-id="${c.id}">
      <td>${escapeHtml(c.name)}</td>
      <td>${escapeHtml(c.city || '')}</td>
      <td>${escapeHtml(c.state || '')}</td>
    </tr>`
    )
    .join('');

  document.getElementById('noCompanyMatch').classList.toggle('hidden', rows.length > 0);
  document.getElementById('quickAddCompanyBtn').classList.toggle('hidden', !canWrite());

  body.querySelectorAll('tr[data-company-id]').forEach((row) => {
    row.onclick = () => openCompany(Number(row.dataset.companyId));
  });
}

function repOptions(selectedIds = []) {
  return state.reps
    .map((rep) => `<option value="${rep.id}" ${selectedIds.includes(rep.id) ? 'selected' : ''}>${escapeHtml(rep.full_name)}</option>`)
    .join('');
}

async function openCompany(companyId, pushHistory = true) {
  const [companyData, contactsData, interactionsData] = await Promise.all([
    api(`/api/companies/${companyId}`),
    api(`/api/customers?companyId=${companyId}`),
    api(`/api/interactions?companyId=${companyId}`)
  ]);

  state.currentCompany = companyData.company;
  state.currentCompany.assignedReps = companyData.assignedReps;
  state.companyContacts = contactsData.customers;
  state.companyInteractions = interactionsData.interactions;

  renderCompanyDetail();
  setView('companyDetailView', state.currentCompany.name, pushHistory);
}

function renderCompanyDetail() {
  const c = state.currentCompany;
  const assignedIds = (c.assignedReps || []).map((r) => r.id);
  const readOnly = canWrite() ? '' : 'disabled';

  document.getElementById('companyEditForm').innerHTML = `
    <label>Name <input name="name" value="${escapeHtml(c.name || '')}" ${readOnly} required /></label>
    <label>Address <input name="address" value="${escapeHtml(c.address || '')}" ${readOnly} /></label>
    <label>City <input name="city" value="${escapeHtml(c.city || '')}" ${readOnly} /></label>
    <label>State <input name="state" maxlength="2" value="${escapeHtml(c.state || '')}" ${readOnly} /></label>
    <label>Zip <input name="zip" value="${escapeHtml(c.zip || '')}" ${readOnly} /></label>
    <label>URL <input name="url" value="${escapeHtml(c.url || '')}" ${readOnly} /></label>
    <label>Segment <input name="segment" value="${escapeHtml(c.segment || '')}" ${readOnly} /></label>
    <label>Customer type <input name="customerType" value="${escapeHtml(c.customer_type || '')}" ${readOnly} /></label>
    <label class="full">Notes <textarea name="notes" ${readOnly}>${escapeHtml(c.notes || '')}</textarea></label>
    <label class="full">Assigned reps
      <select id="companyRepIds" multiple ${readOnly}>${repOptions(assignedIds)}</select>
    </label>
    <div class="row wrap full">
      <button type="submit" ${readOnly}>Save Company</button>
      <button type="button" id="saveCompanyRepsBtn" ${readOnly}>Save Rep Assignments</button>
      <button type="button" id="suggestRepsBtn" class="ghost" ${readOnly}>Suggest by Area</button>
      <button type="button" id="deleteCompanyBtn" class="danger" ${readOnly}>Delete Company</button>
    </div>
  `;

  const contactsBody = document.getElementById('contactsBody');
  contactsBody.innerHTML = state.companyContacts
    .map(
      (contact) => `<tr class="clickable" data-contact-id="${contact.id}">
        <td>${escapeHtml(contact.first_name)} ${escapeHtml(contact.last_name)}</td>
        <td>${escapeHtml(contact.email || '')}</td>
        <td>${escapeHtml(contact.phone || '')}</td>
      </tr>`
    )
    .join('');

  const interactionsBody = document.getElementById('interactionsBody');
  interactionsBody.innerHTML = state.companyInteractions
    .map(
      (i) => `<tr class="clickable" data-interaction-id="${i.id}">
        <td>${new Date(i.created_at).toLocaleString()}</td>
        <td>${escapeHtml(i.rep_name || '')}</td>
        <td>${escapeHtml(i.interaction_type || '')}</td>
        <td>${escapeHtml(i.meeting_notes || '')}</td>
        <td>${escapeHtml(i.next_action || '')}${i.next_action_at ? `<br/><small>${new Date(i.next_action_at).toLocaleString()}</small>` : ''}</td>
      </tr>`
    )
    .join('');

  document.getElementById('newContactBtn').disabled = !canWrite();
  document.getElementById('newInteractionBtn').disabled = !canWrite();

  bindCompanyDetailEvents();
}

function bindCompanyDetailEvents() {
  const form = document.getElementById('companyEditForm');
  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api(`/api/companies/${state.currentCompany.id}`, {
        method: 'PUT',
        body: JSON.stringify({
          name: fd.get('name'),
          address: fd.get('address'),
          city: fd.get('city'),
          state: String(fd.get('state') || '').toUpperCase(),
          zip: fd.get('zip'),
          url: fd.get('url'),
          segment: fd.get('segment'),
          customerType: fd.get('customerType'),
          notes: fd.get('notes')
        })
      });
      await loadCompanies();
      await openCompany(state.currentCompany.id, false);
      showToast('Company updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.getElementById('saveCompanyRepsBtn').onclick = async () => {
    const repIds = Array.from(document.getElementById('companyRepIds').selectedOptions).map((o) => Number(o.value));
    try {
      await api(`/api/companies/${state.currentCompany.id}/reps`, { method: 'POST', body: JSON.stringify({ repIds }) });
      await openCompany(state.currentCompany.id, false);
      showToast('Rep assignments updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.getElementById('suggestRepsBtn').onclick = async () => {
    const query = new URLSearchParams({
      city: state.currentCompany.city || '',
      state: state.currentCompany.state || '',
      zip: state.currentCompany.zip || ''
    });
    try {
      const res = await api(`/api/reps/suggest?${query.toString()}`);
      const ids = new Set(res.suggestedReps.map((rep) => rep.id));
      const select = document.getElementById('companyRepIds');
      Array.from(select.options).forEach((opt) => {
        if (ids.has(Number(opt.value))) opt.selected = true;
      });
      showToast(`Suggested ${res.suggestedReps.length} reps`);
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.getElementById('deleteCompanyBtn').onclick = async () => {
    if (!confirm('Delete this company?')) return;
    try {
      await api(`/api/companies/${state.currentCompany.id}`, { method: 'DELETE' });
      await loadCompanies();
      setView('companyListView', 'Company list');
      showToast('Company deleted');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.getElementById('newContactBtn').onclick = () => openContactCreate(state.currentCompany.id);
  document.getElementById('newInteractionBtn').onclick = () => openInteractionCreate(state.currentCompany.id);

  document.querySelectorAll('[data-contact-id]').forEach((row) => {
    row.onclick = () => openContactDetail(Number(row.dataset.contactId));
  });

  document.querySelectorAll('[data-interaction-id]').forEach((row) => {
    row.onclick = () => openInteractionDetail(Number(row.dataset.interactionId));
  });
}

async function openContactCreate(companyId) {
  const company = state.companies.find((c) => c.id === companyId) || state.currentCompany;
  const form = document.getElementById('contactCreateForm');
  form.innerHTML = `
    <label>Company <input value="${escapeHtml(company?.name || '')}" disabled /></label>
    <label>First name <input name="firstName" required /></label>
    <label>Last name <input name="lastName" required /></label>
    <label>Email <input name="email" type="email" /></label>
    <label>Phone <input name="phone" /></label>
    <label class="full">Notes <textarea name="notes"></textarea></label>
    <div class="row wrap full">
      <button type="submit">Create Contact</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api('/api/customers', {
        method: 'POST',
        body: JSON.stringify({
          companyId,
          firstName: fd.get('firstName'),
          lastName: fd.get('lastName'),
          email: fd.get('email'),
          phone: fd.get('phone'),
          notes: fd.get('notes')
        })
      });
      await openCompany(companyId, false);
      showToast('Contact created');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  setView('contactCreateView', `New Contact • ${company?.name || ''}`);
}

async function openContactDetail(contactId) {
  const { customer } = await api(`/api/customers/${contactId}`);
  const readOnly = canWrite() ? '' : 'disabled';
  const form = document.getElementById('contactEditForm');

  form.innerHTML = `
    <label>Company <input value="${escapeHtml(customer.company_name)}" disabled /></label>
    <label>First name <input name="firstName" value="${escapeHtml(customer.first_name)}" ${readOnly} required /></label>
    <label>Last name <input name="lastName" value="${escapeHtml(customer.last_name)}" ${readOnly} required /></label>
    <label>Email <input name="email" type="email" value="${escapeHtml(customer.email || '')}" ${readOnly} /></label>
    <label>Phone <input name="phone" value="${escapeHtml(customer.phone || '')}" ${readOnly} /></label>
    <label class="full">Notes <textarea name="notes" ${readOnly}>${escapeHtml(customer.notes || '')}</textarea></label>
    <div class="row wrap full">
      <button type="submit" ${readOnly}>Save Contact</button>
      <button id="deleteContactBtn" type="button" class="danger" ${readOnly}>Delete Contact</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api(`/api/customers/${contactId}`, {
        method: 'PUT',
        body: JSON.stringify({
          companyId: customer.company_id,
          firstName: fd.get('firstName'),
          lastName: fd.get('lastName'),
          email: fd.get('email'),
          phone: fd.get('phone'),
          notes: fd.get('notes')
        })
      });
      await openCompany(customer.company_id, false);
      showToast('Contact updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  const delBtn = document.getElementById('deleteContactBtn');
  delBtn.onclick = async () => {
    if (!confirm('Delete this contact?')) return;
    try {
      await api(`/api/customers/${contactId}`, { method: 'DELETE' });
      await openCompany(customer.company_id, false);
      showToast('Contact deleted');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  setView('contactDetailView', `Contact • ${customer.first_name} ${customer.last_name}`);
}

async function openInteractionCreate(companyId) {
  const [company, customers] = await Promise.all([
    api(`/api/companies/${companyId}`),
    api(`/api/customers?companyId=${companyId}`)
  ]);

  const form = document.getElementById('interactionCreateForm');
  form.innerHTML = `
    <label>Company <input value="${escapeHtml(company.company.name)}" disabled /></label>
    <label>Customer
      <select name="customerId">
        <option value="">--</option>
        ${customers.customers
          .map((c) => `<option value="${c.id}">${escapeHtml(c.first_name)} ${escapeHtml(c.last_name)}</option>`)
          .join('')}
      </select>
    </label>
    <label>Rep
      <select name="repId">
        <option value="">--</option>
        ${state.reps.map((r) => `<option value="${r.id}">${escapeHtml(r.full_name)}</option>`).join('')}
      </select>
    </label>
    <label>Type <input name="interactionType" /></label>
    <label class="full">Meeting notes <textarea name="meetingNotes" required></textarea></label>
    <label>Next action <input name="nextAction" /></label>
    <label>Next action date/time <input name="nextActionAt" type="datetime-local" /></label>
    <div class="row wrap full">
      <button type="submit">Create Interaction</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api('/api/interactions', {
        method: 'POST',
        body: JSON.stringify({
          companyId,
          customerId: fd.get('customerId') ? Number(fd.get('customerId')) : null,
          repId: fd.get('repId') ? Number(fd.get('repId')) : null,
          interactionType: fd.get('interactionType'),
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? new Date(String(fd.get('nextActionAt'))).toISOString() : null
        })
      });
      await openCompany(companyId, false);
      showToast('Interaction created');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  setView('interactionCreateView', `New Interaction • ${company.company.name}`);
}

async function openInteractionDetail(interactionId) {
  const { interaction } = await api(`/api/interactions/${interactionId}`);
  const companyCustomers = await api(`/api/customers?companyId=${interaction.company_id}`);
  const readOnly = canWrite() ? '' : 'disabled';
  const form = document.getElementById('interactionEditForm');

  form.innerHTML = `
    <label>Company <input value="${escapeHtml(interaction.company_name)}" disabled /></label>
    <label>Customer
      <select name="customerId" ${readOnly}>
        <option value="">--</option>
        ${companyCustomers.customers
          .map(
            (c) =>
              `<option value="${c.id}" ${interaction.customer_id === c.id ? 'selected' : ''}>${escapeHtml(c.first_name)} ${escapeHtml(c.last_name)}</option>`
          )
          .join('')}
      </select>
    </label>
    <label>Rep
      <select name="repId" ${readOnly}>
        <option value="">--</option>
        ${state.reps
          .map((r) => `<option value="${r.id}" ${interaction.rep_id === r.id ? 'selected' : ''}>${escapeHtml(r.full_name)}</option>`)
          .join('')}
      </select>
    </label>
    <label>Type <input name="interactionType" value="${escapeHtml(interaction.interaction_type || '')}" ${readOnly} /></label>
    <label class="full">Meeting notes <textarea name="meetingNotes" ${readOnly} required>${escapeHtml(interaction.meeting_notes || '')}</textarea></label>
    <label>Next action <input name="nextAction" value="${escapeHtml(interaction.next_action || '')}" ${readOnly} /></label>
    <label>Next action date/time <input name="nextActionAt" type="datetime-local" value="${
      interaction.next_action_at ? new Date(interaction.next_action_at).toISOString().slice(0, 16) : ''
    }" ${readOnly} /></label>
    <div class="row wrap full">
      <button type="submit" ${readOnly}>Save Interaction</button>
      <button id="deleteInteractionBtn" type="button" class="danger" ${readOnly}>Delete Interaction</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api(`/api/interactions/${interactionId}`, {
        method: 'PUT',
        body: JSON.stringify({
          companyId: interaction.company_id,
          customerId: fd.get('customerId') ? Number(fd.get('customerId')) : null,
          repId: fd.get('repId') ? Number(fd.get('repId')) : null,
          interactionType: fd.get('interactionType'),
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? new Date(String(fd.get('nextActionAt'))).toISOString() : null
        })
      });
      await openCompany(interaction.company_id, false);
      showToast('Interaction updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.getElementById('deleteInteractionBtn').onclick = async () => {
    if (!confirm('Delete this interaction?')) return;
    try {
      await api(`/api/interactions/${interactionId}`, { method: 'DELETE' });
      await openCompany(interaction.company_id, false);
      showToast('Interaction deleted');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  setView('interactionDetailView', `Interaction • ${interaction.company_name}`);
}

async function renderRepsView() {
  const data = await api('/api/reps/with-assignments');
  state.reps = data.reps;
  state.repAssignments = data.assignments;
  state.repTerritories = data.territories;

  document.getElementById('repCreateForm').innerHTML = `
    <input name="fullName" placeholder="Full name" required />
    <input name="email" placeholder="Email" />
    <input name="phone" placeholder="Phone" />
    <input name="companyName" placeholder="Company" />
    <button type="submit">Add Rep</button>
  `;

  document.getElementById('repsBody').innerHTML = state.reps
    .map((rep) => {
      const companies = state.repAssignments.filter((a) => a.rep_id === rep.id).map((a) => a.company_name);
      const territories = state.repTerritories.filter((t) => t.rep_id === rep.id);
      return `<tr>
        <td>${escapeHtml(rep.full_name)}</td>
        <td>${escapeHtml(rep.email || '')}</td>
        <td>${escapeHtml(rep.phone || '')}</td>
        <td>${escapeHtml(companies.join(', ') || '-')}</td>
        <td><button class="ghost" data-show-territories="${rep.id}">Show (${territories.length})</button></td>
      </tr>`;
    })
    .join('');

  document.getElementById('territoryForm').innerHTML = `
    <select name="repId" required>
      <option value="">Rep</option>
      ${state.reps.map((rep) => `<option value="${rep.id}">${escapeHtml(rep.full_name)}</option>`).join('')}
    </select>
    <select name="territoryType" required>
      <option value="state">State</option>
      <option value="city_state">City + State</option>
      <option value="zip_prefix">Zip Prefix</option>
      <option value="zip_exact">Zip Exact</option>
    </select>
    <input name="state" placeholder="State (CA)" />
    <input name="city" placeholder="City" />
    <input name="zipPrefix" placeholder="Zip prefix" />
    <input name="zipExact" placeholder="Zip exact" />
    <button type="submit">Add Territory</button>
  `;

  bindRepsEvents();
  setView('repsView', 'Manage reps');
}

function bindRepsEvents() {
  const repCreateForm = document.getElementById('repCreateForm');
  repCreateForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(repCreateForm);
    try {
      await api('/api/reps', {
        method: 'POST',
        body: JSON.stringify({
          fullName: fd.get('fullName'),
          email: fd.get('email'),
          phone: fd.get('phone'),
          companyName: fd.get('companyName')
        })
      });
      await renderRepsView();
      showToast('Rep created');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.querySelectorAll('[data-show-territories]').forEach((btn) => {
    btn.onclick = () => {
      const repId = Number(btn.dataset.showTerritories);
      const items = state.repTerritories.filter((t) => t.rep_id === repId);
      document.getElementById('territoryList').innerHTML = items
        .map(
          (item) => `<li>
            <span>${escapeHtml(item.territory_type)} | ${escapeHtml(item.city || '')} ${escapeHtml(item.state || '')} ${escapeHtml(item.zip_prefix || item.zip_exact || '')}</span>
            <button class="danger" data-delete-territory="${item.id}">Delete</button>
          </li>`
        )
        .join('');

      document.querySelectorAll('[data-delete-territory]').forEach((delBtn) => {
        delBtn.onclick = async () => {
          try {
            await api(`/api/rep-territories/${Number(delBtn.dataset.deleteTerritory)}`, { method: 'DELETE' });
            await renderRepsView();
            showToast('Territory removed');
          } catch (error) {
            showToast(error.message, true);
          }
        };
      });
    };
  });

  const territoryForm = document.getElementById('territoryForm');
  territoryForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(territoryForm);
    try {
      await api('/api/rep-territories', {
        method: 'POST',
        body: JSON.stringify({
          repId: Number(fd.get('repId')),
          territoryType: fd.get('territoryType'),
          state: fd.get('state'),
          city: fd.get('city'),
          zipPrefix: fd.get('zipPrefix'),
          zipExact: fd.get('zipExact')
        })
      });
      territoryForm.reset();
      await renderRepsView();
      showToast('Territory added');
    } catch (error) {
      showToast(error.message, true);
    }
  };
}

async function loadSession() {
  if (!state.token) {
    setView('authView', 'Sign in', false);
    return;
  }

  try {
    const me = await api('/api/auth/me');
    state.user = me.user;
    els.whoami.textContent = `${state.user.fullName} (${state.user.role})`;
    els.whoami.classList.remove('hidden');
    els.logoutBtn.classList.remove('hidden');
    els.manageRepsBtn.classList.toggle('hidden', !canManageReps());
    document.getElementById('showCreateCompanyBtn').classList.toggle('hidden', !canWrite());

    await Promise.all([loadCompanies(), loadReps()]);
    setView('companyListView', 'Company list', false);
  } catch {
    localStorage.removeItem('crm_token');
    state.token = null;
    setView('authView', 'Sign in', false);
  }
}

document.getElementById('bootstrapForm').onsubmit = async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    await api('/api/auth/bootstrap', {
      method: 'POST',
      body: JSON.stringify({ email: fd.get('email'), fullName: fd.get('fullName'), password: fd.get('password') })
    });
    showToast('Admin created, now log in');
  } catch (error) {
    showToast(error.message, true);
  }
};

document.getElementById('loginForm').onsubmit = async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    const result = await api('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: fd.get('email'), password: fd.get('password') })
    });
    state.token = result.token;
    localStorage.setItem('crm_token', state.token);
    await loadSession();
    showToast('Logged in');
  } catch (error) {
    showToast(error.message, true);
  }
};

els.logoutBtn.onclick = async () => {
  try {
    await api('/api/auth/logout', { method: 'POST' });
  } catch {
  }
  state.token = null;
  state.user = null;
  state.currentCompany = null;
  state.history = [];
  localStorage.removeItem('crm_token');
  els.whoami.classList.add('hidden');
  els.logoutBtn.classList.add('hidden');
  els.manageRepsBtn.classList.add('hidden');
  setView('authView', 'Sign in', false);
};

els.backBtn.onclick = async () => {
  const previous = state.history.pop();
  if (!previous) {
    setView('companyListView', 'Company list', false);
    return;
  }
  if (previous === 'companyDetailView' && state.currentCompany?.id) {
    await openCompany(state.currentCompany.id, false);
    return;
  }
  if (previous === 'companyListView') {
    setView('companyListView', 'Company list', false);
    return;
  }
  setView(previous, els.pageHint.textContent, false);
};

els.manageRepsBtn.onclick = async () => {
  try {
    await renderRepsView();
  } catch (error) {
    showToast(error.message, true);
  }
};

document.getElementById('companySearch').oninput = (event) => {
  state.companyFilter = event.target.value;
  renderCompanies();
};

function toggleCreateCompany(show) {
  document.getElementById('createCompanyForm').classList.toggle('hidden', !show);
}

document.getElementById('showCreateCompanyBtn').onclick = () => toggleCreateCompany(true);
document.getElementById('quickAddCompanyBtn').onclick = () => toggleCreateCompany(true);

document.getElementById('createCompanyForm').onsubmit = async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    await api('/api/companies', {
      method: 'POST',
      body: JSON.stringify({
        name: fd.get('name'),
        address: fd.get('address'),
        city: fd.get('city'),
        state: String(fd.get('state') || '').toUpperCase(),
        zip: fd.get('zip'),
        url: fd.get('url'),
        segment: fd.get('segment'),
        customerType: fd.get('customerType'),
        notes: fd.get('notes')
      })
    });
    event.target.reset();
    toggleCreateCompany(false);
    await loadCompanies();
    showToast('Company created');
  } catch (error) {
    showToast(error.message, true);
  }
};

loadSession();
