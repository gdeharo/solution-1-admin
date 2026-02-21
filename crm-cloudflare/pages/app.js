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
  companyFilter: ''
};

const API_BASE = window.CRM_API_BASE || '';

const els = {
  authView: document.getElementById('authView'),
  companyListView: document.getElementById('companyListView'),
  companyDetailView: document.getElementById('companyDetailView'),
  repsView: document.getElementById('repsView'),
  pageHint: document.getElementById('pageHint'),
  backToListBtn: document.getElementById('backToListBtn'),
  manageRepsBtn: document.getElementById('manageRepsBtn'),
  backFromRepsBtn: document.getElementById('backFromRepsBtn'),
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

function setView(view) {
  const views = ['authView', 'companyListView', 'companyDetailView', 'repsView'];
  views.forEach((v) => els[v].classList.add('hidden'));
  els[view].classList.remove('hidden');

  if (view === 'companyListView') {
    els.pageHint.textContent = 'Company list';
    els.backToListBtn.classList.add('hidden');
  }
  if (view === 'companyDetailView') {
    els.pageHint.textContent = state.currentCompany ? state.currentCompany.name : 'Company';
    els.backToListBtn.classList.remove('hidden');
  }
  if (view === 'repsView') {
    els.pageHint.textContent = 'Manage reps';
    els.backToListBtn.classList.add('hidden');
  }
}

async function api(path, options = {}) {
  const headers = new Headers(options.headers || {});
  if (!headers.has('content-type') && !(options.body instanceof FormData)) {
    headers.set('content-type', 'application/json');
  }
  if (state.token) headers.set('authorization', `Bearer ${state.token}`);

  const response = await fetch(`${API_BASE}${path}`, { ...options, headers });
  let data;
  try {
    data = await response.json();
  } catch {
    data = null;
  }

  if (!response.ok) {
    throw new Error(data?.error || `Request failed (${response.status})`);
  }
  return data;
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
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
  return state.companies.filter((c) => {
    const haystack = `${c.name || ''} ${c.city || ''} ${c.state || ''}`.toLowerCase();
    return haystack.includes(q);
  });
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
    row.addEventListener('click', () => {
      openCompany(Number(row.dataset.companyId));
    });
  });
}

function repOptions(selectedIds = []) {
  return state.reps
    .map((rep) => `<option value="${rep.id}" ${selectedIds.includes(rep.id) ? 'selected' : ''}>${escapeHtml(rep.full_name)}</option>`)
    .join('');
}

async function openCompany(companyId) {
  const [companyData, customersData, interactionsData] = await Promise.all([
    api(`/api/companies/${companyId}`),
    api(`/api/customers?companyId=${companyId}`),
    api(`/api/interactions?companyId=${companyId}`)
  ]);

  state.currentCompany = companyData.company;
  state.currentCompany.assignedReps = companyData.assignedReps;
  state.companyContacts = customersData.customers;
  state.companyInteractions = interactionsData.interactions;

  renderCompanyDetail();
  setView('companyDetailView');
}

function renderCompanyDetail() {
  const c = state.currentCompany;
  const assignedRepIds = (c.assignedReps || []).map((r) => r.id);
  const readOnly = canWrite() ? '' : 'disabled';

  document.getElementById('companyEditForm').innerHTML = `
    <label>Name <input name="name" value="${escapeHtml(c.name || '')}" ${readOnly} required /></label>
    <label>Address <input name="address" value="${escapeHtml(c.address || '')}" ${readOnly} /></label>
    <label>City <input name="city" value="${escapeHtml(c.city || '')}" ${readOnly} /></label>
    <label>State <input name="state" value="${escapeHtml(c.state || '')}" maxlength="2" ${readOnly} /></label>
    <label>Zip <input name="zip" value="${escapeHtml(c.zip || '')}" ${readOnly} /></label>
    <label>Contact name <input name="contactName" value="${escapeHtml(c.contact_name || '')}" ${readOnly} /></label>
    <label>Contact email <input name="contactEmail" value="${escapeHtml(c.contact_email || '')}" ${readOnly} /></label>
    <label>Contact phone <input name="contactPhone" value="${escapeHtml(c.contact_phone || '')}" ${readOnly} /></label>
    <label>URL <input name="url" value="${escapeHtml(c.url || '')}" ${readOnly} /></label>
    <label>Segment <input name="segment" value="${escapeHtml(c.segment || '')}" ${readOnly} /></label>
    <label>Customer type <input name="customerType" value="${escapeHtml(c.customer_type || '')}" ${readOnly} /></label>
    <label class="full">Notes <textarea name="notes" ${readOnly}>${escapeHtml(c.notes || '')}</textarea></label>
    <label class="full">Assigned reps
      <select id="companyRepIds" multiple ${readOnly}>${repOptions(assignedRepIds)}</select>
    </label>
    <div class="row wrap full">
      <button type="submit" ${readOnly}>Save Company</button>
      <button type="button" id="saveCompanyRepsBtn" ${readOnly}>Save Rep Assignments</button>
      <button type="button" id="suggestRepsBtn" class="ghost" ${readOnly}>Suggest by Area</button>
      <button type="button" id="deleteCompanyBtn" class="danger" ${readOnly}>Delete Company</button>
    </div>
  `;

  document.getElementById('contactCreateForm').innerHTML = `
    <input name="firstName" placeholder="First name" ${readOnly} required />
    <input name="lastName" placeholder="Last name" ${readOnly} required />
    <input name="email" placeholder="Email" ${readOnly} />
    <input name="phone" placeholder="Phone" ${readOnly} />
    <button type="submit" ${readOnly}>Add Contact</button>
  `;

  document.getElementById('interactionCreateForm').innerHTML = `
    <select name="repId" ${readOnly}>
      <option value="">Rep</option>
      ${state.reps.map((r) => `<option value="${r.id}">${escapeHtml(r.full_name)}</option>`).join('')}
    </select>
    <input name="interactionType" placeholder="Type" ${readOnly} />
    <input name="meetingNotes" placeholder="Notes" ${readOnly} required />
    <input name="nextAction" placeholder="Next action" ${readOnly} />
    <input name="nextActionAt" type="datetime-local" ${readOnly} />
    <button type="submit" ${readOnly}>Add Interaction</button>
  `;

  document.getElementById('contactsBody').innerHTML = state.companyContacts
    .map(
      (contact) => `<tr>
        <td>${escapeHtml(contact.first_name)} ${escapeHtml(contact.last_name)}</td>
        <td>${escapeHtml(contact.email || '')}</td>
        <td>${escapeHtml(contact.phone || '')}</td>
        <td>
          <button class="ghost" data-edit-contact="${contact.id}" ${readOnly}>Edit</button>
          <button class="danger" data-delete-contact="${contact.id}" ${readOnly}>Delete</button>
        </td>
      </tr>`
    )
    .join('');

  document.getElementById('interactionsBody').innerHTML = state.companyInteractions
    .map(
      (interaction) => `<tr>
        <td>${new Date(interaction.created_at).toLocaleString()}</td>
        <td>${escapeHtml(interaction.rep_name || '')}</td>
        <td>${escapeHtml(interaction.interaction_type || '')}</td>
        <td>${escapeHtml(interaction.meeting_notes || '')}</td>
        <td>${escapeHtml(interaction.next_action || '')}${interaction.next_action_at ? `<br/><small>${new Date(interaction.next_action_at).toLocaleString()}</small>` : ''}</td>
        <td>
          <button class="ghost" data-edit-interaction="${interaction.id}" ${readOnly}>Edit</button>
          <button class="danger" data-delete-interaction="${interaction.id}" ${readOnly}>Delete</button>
        </td>
      </tr>`
    )
    .join('');

  bindCompanyDetailEvents();
}

function bindCompanyDetailEvents() {
  const companyForm = document.getElementById('companyEditForm');
  companyForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    const formData = new FormData(companyForm);
    try {
      await api(`/api/companies/${state.currentCompany.id}`, {
        method: 'PUT',
        body: JSON.stringify({
          name: formData.get('name'),
          address: formData.get('address'),
          city: formData.get('city'),
          state: String(formData.get('state') || '').toUpperCase(),
          zip: formData.get('zip'),
          contactName: formData.get('contactName'),
          contactEmail: formData.get('contactEmail'),
          contactPhone: formData.get('contactPhone'),
          url: formData.get('url'),
          segment: formData.get('segment'),
          customerType: formData.get('customerType'),
          notes: formData.get('notes')
        })
      });
      showToast('Company updated');
      await loadCompanies();
      await openCompany(state.currentCompany.id);
    } catch (error) {
      showToast(error.message, true);
    }
  });

  document.getElementById('saveCompanyRepsBtn').addEventListener('click', async () => {
    const repIds = Array.from(document.getElementById('companyRepIds').selectedOptions).map((o) => Number(o.value));
    try {
      await api(`/api/companies/${state.currentCompany.id}/reps`, {
        method: 'POST',
        body: JSON.stringify({ repIds })
      });
      showToast('Rep assignments updated');
      await openCompany(state.currentCompany.id);
    } catch (error) {
      showToast(error.message, true);
    }
  });

  document.getElementById('suggestRepsBtn').addEventListener('click', async () => {
    const query = new URLSearchParams({
      city: state.currentCompany.city || '',
      state: state.currentCompany.state || '',
      zip: state.currentCompany.zip || ''
    });
    try {
      const suggestions = await api(`/api/reps/suggest?${query.toString()}`);
      const suggestedIds = new Set(suggestions.suggestedReps.map((rep) => rep.id));
      const select = document.getElementById('companyRepIds');
      Array.from(select.options).forEach((option) => {
        if (suggestedIds.has(Number(option.value))) option.selected = true;
      });
      showToast(`Suggested ${suggestions.suggestedReps.length} reps based on area`);
    } catch (error) {
      showToast(error.message, true);
    }
  });

  document.getElementById('deleteCompanyBtn').addEventListener('click', async () => {
    if (!confirm('Delete this company?')) return;
    try {
      await api(`/api/companies/${state.currentCompany.id}`, { method: 'DELETE' });
      showToast('Company deleted');
      await loadCompanies();
      setView('companyListView');
    } catch (error) {
      showToast(error.message, true);
    }
  });

  const contactForm = document.getElementById('contactCreateForm');
  contactForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    const fd = new FormData(contactForm);
    try {
      await api('/api/customers', {
        method: 'POST',
        body: JSON.stringify({
          companyId: state.currentCompany.id,
          firstName: fd.get('firstName'),
          lastName: fd.get('lastName'),
          email: fd.get('email'),
          phone: fd.get('phone')
        })
      });
      contactForm.reset();
      await openCompany(state.currentCompany.id);
      showToast('Contact added');
    } catch (error) {
      showToast(error.message, true);
    }
  });

  document.querySelectorAll('[data-edit-contact]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const id = Number(btn.dataset.editContact);
      const current = state.companyContacts.find((c) => c.id === id);
      if (!current) return;

      const firstName = prompt('First name', current.first_name);
      if (!firstName) return;
      const lastName = prompt('Last name', current.last_name);
      if (!lastName) return;
      const email = prompt('Email', current.email || '') || '';
      const phone = prompt('Phone', current.phone || '') || '';

      try {
        await api(`/api/customers/${id}`, {
          method: 'PUT',
          body: JSON.stringify({
            companyId: state.currentCompany.id,
            firstName,
            lastName,
            email,
            phone,
            notes: current.notes || ''
          })
        });
        await openCompany(state.currentCompany.id);
        showToast('Contact updated');
      } catch (error) {
        showToast(error.message, true);
      }
    });
  });

  document.querySelectorAll('[data-delete-contact]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const id = Number(btn.dataset.deleteContact);
      if (!confirm('Delete this contact?')) return;
      try {
        await api(`/api/customers/${id}`, { method: 'DELETE' });
        await openCompany(state.currentCompany.id);
        showToast('Contact deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    });
  });

  const interactionForm = document.getElementById('interactionCreateForm');
  interactionForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    const fd = new FormData(interactionForm);
    try {
      await api('/api/interactions', {
        method: 'POST',
        body: JSON.stringify({
          companyId: state.currentCompany.id,
          repId: fd.get('repId') ? Number(fd.get('repId')) : null,
          interactionType: fd.get('interactionType'),
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? new Date(String(fd.get('nextActionAt'))).toISOString() : null
        })
      });
      interactionForm.reset();
      await openCompany(state.currentCompany.id);
      showToast('Interaction added');
    } catch (error) {
      showToast(error.message, true);
    }
  });

  document.querySelectorAll('[data-edit-interaction]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const id = Number(btn.dataset.editInteraction);
      const current = state.companyInteractions.find((i) => i.id === id);
      if (!current) return;

      const interactionType = prompt('Type', current.interaction_type || '') || '';
      const meetingNotes = prompt('Meeting notes', current.meeting_notes || '');
      if (!meetingNotes) return;
      const nextAction = prompt('Next action', current.next_action || '') || '';

      try {
        await api(`/api/interactions/${id}`, {
          method: 'PUT',
          body: JSON.stringify({
            companyId: state.currentCompany.id,
            customerId: current.customer_id || null,
            repId: current.rep_id || null,
            interactionType,
            meetingNotes,
            nextAction,
            nextActionAt: current.next_action_at || null
          })
        });
        await openCompany(state.currentCompany.id);
        showToast('Interaction updated');
      } catch (error) {
        showToast(error.message, true);
      }
    });
  });

  document.querySelectorAll('[data-delete-interaction]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const id = Number(btn.dataset.deleteInteraction);
      if (!confirm('Delete this interaction?')) return;
      try {
        await api(`/api/interactions/${id}`, { method: 'DELETE' });
        await openCompany(state.currentCompany.id);
        showToast('Interaction deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    });
  });
}

async function renderRepsView() {
  const [withAssignments] = await Promise.all([api('/api/reps/with-assignments')]);
  state.reps = withAssignments.reps;
  state.repAssignments = withAssignments.assignments;
  state.repTerritories = withAssignments.territories;

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
        <td>
          <button class="ghost" data-show-territories="${rep.id}">Show (${territories.length})</button>
        </td>
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
  setView('repsView');
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
      showToast('Rep created');
      await renderRepsView();
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
            showToast('Territory removed');
            await renderRepsView();
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
      showToast('Territory added');
      territoryForm.reset();
      await renderRepsView();
    } catch (error) {
      showToast(error.message, true);
    }
  };
}

async function loadSession() {
  if (!state.token) {
    setView('authView');
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
    setView('companyListView');
  } catch {
    localStorage.removeItem('crm_token');
    state.token = null;
    setView('authView');
  }
}

document.getElementById('bootstrapForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    await api('/api/auth/bootstrap', {
      method: 'POST',
      body: JSON.stringify({
        email: fd.get('email'),
        fullName: fd.get('fullName'),
        password: fd.get('password')
      })
    });
    showToast('Admin created, now log in.');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('loginForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    const result = await api('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: fd.get('email'), password: fd.get('password') })
    });
    state.token = result.token;
    state.user = result.user;
    localStorage.setItem('crm_token', state.token);
    await loadSession();
    showToast('Logged in');
  } catch (error) {
    showToast(error.message, true);
  }
});

els.logoutBtn.addEventListener('click', async () => {
  try {
    await api('/api/auth/logout', { method: 'POST' });
  } catch {
  }
  localStorage.removeItem('crm_token');
  state.token = null;
  state.user = null;
  els.whoami.classList.add('hidden');
  els.logoutBtn.classList.add('hidden');
  els.manageRepsBtn.classList.add('hidden');
  setView('authView');
});

els.backToListBtn.addEventListener('click', () => {
  setView('companyListView');
});

els.manageRepsBtn.addEventListener('click', async () => {
  try {
    await renderRepsView();
  } catch (error) {
    showToast(error.message, true);
  }
});

els.backFromRepsBtn.addEventListener('click', () => {
  setView('companyListView');
});

document.getElementById('companySearch').addEventListener('input', (event) => {
  state.companyFilter = event.target.value;
  renderCompanies();
});

function toggleCreateCompany(show) {
  document.getElementById('createCompanyForm').classList.toggle('hidden', !show);
}

document.getElementById('showCreateCompanyBtn').addEventListener('click', () => toggleCreateCompany(true));
document.getElementById('quickAddCompanyBtn').addEventListener('click', () => toggleCreateCompany(true));

document.getElementById('createCompanyForm').addEventListener('submit', async (event) => {
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
        contactName: fd.get('contactName'),
        contactEmail: fd.get('contactEmail'),
        contactPhone: fd.get('contactPhone'),
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
});

loadSession();
