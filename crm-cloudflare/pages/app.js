const state = {
  token: localStorage.getItem('crm_token') || null,
  user: null,
  companies: [],
  customers: [],
  reps: [],
  interactions: [],
  users: []
};

const els = {
  authPanel: document.getElementById('authPanel'),
  appPanel: document.getElementById('appPanel'),
  adminPanel: document.getElementById('adminPanel'),
  sessionInfo: document.getElementById('sessionInfo'),
  whoami: document.getElementById('whoami'),
  toast: document.getElementById('toast')
};

const API_BASE = window.CRM_API_BASE || '';

async function api(path, options = {}) {
  const headers = new Headers(options.headers || {});
  if (!headers.has('content-type') && !(options.body instanceof FormData)) {
    headers.set('content-type', 'application/json');
  }
  if (state.token) headers.set('authorization', `Bearer ${state.token}`);

  const res = await fetch(`${API_BASE}${path}`, { ...options, headers });
  let data = null;
  try {
    data = await res.json();
  } catch {
    data = null;
  }

  if (!res.ok) {
    throw new Error(data?.error || `Request failed (${res.status})`);
  }
  return data;
}

function showToast(message, isError = false) {
  els.toast.textContent = message;
  els.toast.classList.remove('hidden', 'error');
  if (isError) els.toast.classList.add('error');
  setTimeout(() => els.toast.classList.add('hidden'), 2200);
}

function optionList(items, labelKey = 'name', valueKey = 'id', includeBlank = true) {
  const blank = includeBlank ? '<option value="">--</option>' : '';
  return `${blank}${items
    .map((x) => `<option value="${x[valueKey]}">${x[labelKey]}</option>`)
    .join('')}`;
}

function repMultiOptions() {
  return state.reps.map((r) => `<option value="${r.id}">${r.full_name}</option>`).join('');
}

function getMultiValues(selectId) {
  return Array.from(document.getElementById(selectId).selectedOptions).map((o) => Number(o.value));
}

function setAuthView(authed) {
  els.authPanel.classList.toggle('hidden', authed);
  els.appPanel.classList.toggle('hidden', !authed);
  els.sessionInfo.classList.toggle('hidden', !authed);
}

function renderCompanies() {
  document.getElementById('companiesBody').innerHTML = state.companies
    .map(
      (c) => `<tr>
        <td>${c.name}</td>
        <td>${c.segment || ''}</td>
        <td>${c.customer_type || ''}</td>
        <td>${c.customer_count}</td>
        <td>${c.rep_count}</td>
      </tr>`
    )
    .join('');

  const companyOpts = optionList(state.companies, 'name');
  document.getElementById('customerCompanyId').innerHTML = companyOpts;
  document.getElementById('interactionCompanyId').innerHTML = companyOpts;
  document.getElementById('companyLookupSelect').innerHTML = companyOpts;
  document.getElementById('companyFileEntity').innerHTML = companyOpts;
}

function renderCustomers() {
  document.getElementById('customersBody').innerHTML = state.customers
    .map(
      (c) => `<tr>
        <td>${c.first_name} ${c.last_name}</td>
        <td>${c.company_name}</td>
        <td>${c.email || ''}</td>
        <td>${c.phone || ''}</td>
      </tr>`
    )
    .join('');

  document.getElementById('interactionCustomerId').innerHTML = optionList(
    state.customers.map((c) => ({ id: c.id, name: `${c.first_name} ${c.last_name} (${c.company_name})` }))
  );
  document.getElementById('customerFileEntity').innerHTML = optionList(
    state.customers.map((c) => ({ id: c.id, name: `${c.first_name} ${c.last_name}` }))
  );
}

function renderReps() {
  document.getElementById('repsBody').innerHTML = state.reps
    .map(
      (r) => `<tr>
        <td>${r.full_name}</td>
        <td>${r.company_name || ''}${r.is_independent ? ' (Independent)' : ''}</td>
        <td>${r.email || ''}</td>
        <td>${r.phone || ''}</td>
      </tr>`
    )
    .join('');

  document.getElementById('interactionRepId').innerHTML = optionList(
    state.reps.map((r) => ({ id: r.id, name: r.full_name }))
  );
  document.getElementById('companyRepIds').innerHTML = repMultiOptions();
  document.getElementById('customerRepIds').innerHTML = repMultiOptions();
}

function renderInteractions() {
  document.getElementById('interactionsBody').innerHTML = state.interactions
    .map(
      (i) => `<tr>
        <td>${i.company_name}</td>
        <td>${i.customer_name || ''}</td>
        <td>${i.rep_name || ''}</td>
        <td>${i.meeting_notes || ''}</td>
        <td>${i.next_action || ''}${i.next_action_at ? `<br/><small>${new Date(i.next_action_at).toLocaleString()}</small>` : ''}</td>
      </tr>`
    )
    .join('');

  document.getElementById('interactionFileEntity').innerHTML = optionList(
    state.interactions.map((i) => ({ id: i.id, name: `${i.company_name} #${i.id}` }))
  );
}

function renderUsers() {
  document.getElementById('usersBody').innerHTML = state.users
    .map(
      (u) => `<tr>
        <td>${u.email}</td>
        <td>${u.full_name}</td>
        <td>${u.role}</td>
        <td>${u.is_active ? 'yes' : 'no'}</td>
      </tr>`
    )
    .join('');
}

async function loadAttachments(entityType, entityId, listId) {
  if (!entityId) return;
  const data = await api(`/api/attachments?entityType=${entityType}&entityId=${entityId}`);
  document.getElementById(listId).innerHTML = data.attachments
    .map(
      (a) =>
        `<li><a href="${API_BASE}/api/files/${encodeURIComponent(a.file_key)}?token=${encodeURIComponent(
          state.token || ''
        )}" target="_blank" rel="noreferrer">${a.file_name}</a> (${a.mime_type || 'file'})</li>`
    )
    .join('');
}

async function loadData() {
  const [companies, customers, reps, interactions] = await Promise.all([
    api('/api/companies'),
    api('/api/customers'),
    api('/api/reps'),
    api('/api/interactions')
  ]);

  state.companies = companies.companies;
  state.customers = customers.customers;
  state.reps = reps.reps;
  state.interactions = interactions.interactions;

  renderCompanies();
  renderCustomers();
  renderReps();
  renderInteractions();

  if (state.user?.role === 'admin') {
    const users = await api('/api/users');
    state.users = users.users;
    renderUsers();
    els.adminPanel.classList.remove('hidden');
  } else {
    els.adminPanel.classList.add('hidden');
  }
}

async function initSession() {
  if (!state.token) {
    setAuthView(false);
    return;
  }
  try {
    const me = await api('/api/auth/me');
    state.user = me.user;
    els.whoami.textContent = `${state.user.fullName} (${state.user.role})`;
    setAuthView(true);
    await loadData();
  } catch {
    localStorage.removeItem('crm_token');
    state.token = null;
    setAuthView(false);
  }
}

document.getElementById('bootstrapForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    await api('/api/auth/bootstrap', {
      method: 'POST',
      body: JSON.stringify({
        email: form.get('email'),
        fullName: form.get('fullName'),
        password: form.get('password')
      })
    });
    showToast('Initial admin created. You can now log in.');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('loginForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    const res = await api('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email: form.get('email'), password: form.get('password') })
    });
    state.token = res.token;
    localStorage.setItem('crm_token', state.token);
    state.user = res.user;
    els.whoami.textContent = `${state.user.fullName} (${state.user.role})`;
    setAuthView(true);
    await loadData();
    showToast('Logged in');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('logoutBtn').addEventListener('click', async () => {
  try {
    await api('/api/auth/logout', { method: 'POST' });
  } catch {
  }
  localStorage.removeItem('crm_token');
  state.token = null;
  state.user = null;
  setAuthView(false);
});

document.getElementById('companyForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    await api('/api/companies', {
      method: 'POST',
      body: JSON.stringify({
        name: form.get('name'),
        address: form.get('address'),
        contactName: form.get('contactName'),
        contactEmail: form.get('contactEmail'),
        contactPhone: form.get('contactPhone'),
        url: form.get('url'),
        segment: form.get('segment'),
        customerType: form.get('customerType'),
        notes: form.get('notes'),
        repIds: getMultiValues('companyRepIds')
      })
    });
    e.currentTarget.reset();
    await loadData();
    showToast('Company created');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('customerForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    await api('/api/customers', {
      method: 'POST',
      body: JSON.stringify({
        companyId: Number(form.get('companyId')),
        firstName: form.get('firstName'),
        lastName: form.get('lastName'),
        email: form.get('email'),
        phone: form.get('phone'),
        notes: form.get('notes'),
        repIds: getMultiValues('customerRepIds')
      })
    });
    e.currentTarget.reset();
    await loadData();
    showToast('Customer created');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('repForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    await api('/api/reps', {
      method: 'POST',
      body: JSON.stringify({
        fullName: form.get('fullName'),
        companyName: form.get('companyName'),
        email: form.get('email'),
        phone: form.get('phone'),
        segment: form.get('segment'),
        customerType: form.get('customerType'),
        isIndependent: form.get('isIndependent') === 'on'
      })
    });
    e.currentTarget.reset();
    await loadData();
    showToast('Rep created');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('interactionForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    const rawDate = form.get('nextActionAt');
    await api('/api/interactions', {
      method: 'POST',
      body: JSON.stringify({
        companyId: Number(form.get('companyId')),
        customerId: form.get('customerId') ? Number(form.get('customerId')) : null,
        repId: form.get('repId') ? Number(form.get('repId')) : null,
        interactionType: form.get('interactionType'),
        meetingNotes: form.get('meetingNotes'),
        nextAction: form.get('nextAction'),
        nextActionAt: rawDate ? new Date(String(rawDate)).toISOString() : null
      })
    });
    e.currentTarget.reset();
    await loadData();
    showToast('Interaction logged');
  } catch (error) {
    showToast(error.message, true);
  }
});

document.getElementById('userForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const form = new FormData(e.currentTarget);
  try {
    await api('/api/users', {
      method: 'POST',
      body: JSON.stringify({
        email: form.get('email'),
        fullName: form.get('fullName'),
        role: form.get('role'),
        password: form.get('password')
      })
    });
    e.currentTarget.reset();
    await loadData();
    showToast('User created');
  } catch (error) {
    showToast(error.message, true);
  }
});

async function uploadEntityFile(entityType, selectId, inputId, listId) {
  const entityId = Number(document.getElementById(selectId).value);
  const input = document.getElementById(inputId);
  const file = input.files[0];
  if (!entityId || !file) {
    showToast('Select a record and file first', true);
    return;
  }

  const form = new FormData();
  form.set('entityType', entityType);
  form.set('entityId', String(entityId));
  form.set('file', file);

  try {
    await api('/api/files/upload', {
      method: 'POST',
      body: form,
      headers: {}
    });
    input.value = '';
    await loadAttachments(entityType, entityId, listId);
    showToast('File uploaded');
  } catch (error) {
    showToast(error.message, true);
  }
}

document.getElementById('uploadCompanyFileBtn').addEventListener('click', () => {
  uploadEntityFile('company', 'companyFileEntity', 'companyFileInput', 'companyAttachments');
});
document.getElementById('uploadCustomerFileBtn').addEventListener('click', () => {
  uploadEntityFile('customer', 'customerFileEntity', 'customerFileInput', 'customerAttachments');
});
document.getElementById('uploadInteractionFileBtn').addEventListener('click', () => {
  uploadEntityFile('interaction', 'interactionFileEntity', 'interactionFileInput', 'interactionAttachments');
});

['companyFileEntity', 'customerFileEntity', 'interactionFileEntity'].forEach((id) => {
  document.getElementById(id).addEventListener('change', async (e) => {
    const map = {
      companyFileEntity: ['company', 'companyAttachments'],
      customerFileEntity: ['customer', 'customerAttachments'],
      interactionFileEntity: ['interaction', 'interactionAttachments']
    };
    const [type, listId] = map[id];
    const value = Number(e.target.value);
    if (value) {
      await loadAttachments(type, value, listId);
    }
  });
});

document.getElementById('loadCompanyContactsBtn').addEventListener('click', async () => {
  const companyId = Number(document.getElementById('companyLookupSelect').value);
  if (!companyId) return;

  try {
    const res = await api(`/api/companies/${companyId}/customers`);
    document.getElementById('companyContactsBody').innerHTML = res.customers
      .map(
        (c) => `<tr>
          <td>${c.first_name}</td>
          <td>${c.last_name}</td>
          <td>${c.email || ''}</td>
          <td>${c.phone || ''}</td>
        </tr>`
      )
      .join('');
  } catch (error) {
    showToast(error.message, true);
  }
});

initSession();
