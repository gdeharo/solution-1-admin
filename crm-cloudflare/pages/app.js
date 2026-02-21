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
  segments: [],
  customerTypes: [],
  companyFilter: '',
  history: [],
  companyEditMode: false,
  contactEditMode: false
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

const COUNTRY_OPTIONS = [
  ['US', 'United States'],
  ['CA', 'Canada'],
  ['MX', 'Mexico'],
  ['GB', 'United Kingdom'],
  ['DE', 'Germany'],
  ['FR', 'France'],
  ['IT', 'Italy'],
  ['ES', 'Spain'],
  ['NL', 'Netherlands'],
  ['BE', 'Belgium'],
  ['CH', 'Switzerland'],
  ['SE', 'Sweden'],
  ['NO', 'Norway'],
  ['DK', 'Denmark'],
  ['FI', 'Finland'],
  ['IE', 'Ireland'],
  ['PT', 'Portugal'],
  ['PL', 'Poland'],
  ['CZ', 'Czechia'],
  ['AT', 'Austria'],
  ['AU', 'Australia'],
  ['NZ', 'New Zealand'],
  ['JP', 'Japan'],
  ['KR', 'South Korea'],
  ['SG', 'Singapore'],
  ['IN', 'India'],
  ['BR', 'Brazil'],
  ['AR', 'Argentina'],
  ['CL', 'Chile'],
  ['ZA', 'South Africa']
];

const US_STATES = [
  'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME',
  'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA',
  'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'DC'
];

const CA_PROVINCES = ['AB', 'BC', 'MB', 'NB', 'NL', 'NS', 'NT', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT'];
const INTERACTION_TYPE_DEFAULTS = ['Store Visit', 'Other Visit', 'Phone Call', 'Other'];

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

function companyAddressText(company) {
  return [company.address, company.city, company.state, company.zip, company.country].filter(Boolean).join(', ');
}

function companyMapUrl(company) {
  const q = companyAddressText(company);
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(q)}`;
}

function toIsoDateStart(dateValue) {
  return `${dateValue}T00:00:00.000Z`;
}

async function toSquareImageFile(file) {
  const imageBitmap = await createImageBitmap(file);
  const canvas = document.createElement('canvas');
  canvas.width = 720;
  canvas.height = 720;
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  const scale = Math.min(canvas.width / imageBitmap.width, canvas.height / imageBitmap.height);
  const drawW = Math.round(imageBitmap.width * scale);
  const drawH = Math.round(imageBitmap.height * scale);
  const dx = Math.floor((canvas.width - drawW) / 2);
  const dy = Math.floor((canvas.height - drawH) / 2);
  ctx.drawImage(imageBitmap, 0, 0, imageBitmap.width, imageBitmap.height, dx, dy, drawW, drawH);
  const blob = await new Promise((resolve) => canvas.toBlob(resolve, 'image/jpeg', 0.9));
  if (!blob) throw new Error('Could not process image');
  return new File([blob], `contact-photo-${Date.now()}.jpg`, { type: 'image/jpeg' });
}

function showPhotoActionDialog() {
  return new Promise((resolve) => {
    const overlay = document.createElement('div');
    overlay.className = 'action-modal-overlay';
    overlay.innerHTML = `
      <div class="action-modal">
        <h3>Photo Options</h3>
        <div class="row wrap">
          <button type="button" data-choice="replace">Replace</button>
          <button type="button" class="danger" data-choice="delete">Delete</button>
          <button type="button" class="ghost" data-choice="cancel">Cancel</button>
        </div>
      </div>
    `;
    document.body.appendChild(overlay);

    const close = (choice) => {
      overlay.remove();
      resolve(choice);
    };

    overlay.querySelectorAll('[data-choice]').forEach((btn) => {
      btn.onclick = () => close(btn.dataset.choice);
    });

    overlay.onclick = (event) => {
      if (event.target === overlay) close('cancel');
    };
  });
}

function buildCountryOptions(selected = 'US') {
  return COUNTRY_OPTIONS.map(
    ([code, label]) => `<option value="${code}" ${code === selected ? 'selected' : ''}>${code} - ${label}</option>`
  ).join('');
}

function buildStateField(scope, country, currentState = '', disabled = false) {
  const wrapId = scope === 'create' ? 'createCompanyStateWrap' : 'companyStateWrap';
  const dis = disabled ? 'disabled' : '';
  const value = escapeHtml(currentState || '');
  let inner = '';
  if (country === 'US' || country === 'CA') {
    const options = (country === 'US' ? US_STATES : CA_PROVINCES)
      .map((code) => `<option value="${code}" ${code === currentState ? 'selected' : ''}>${code}</option>`)
      .join('');
    inner = `State/Province <select name="state" ${dis}><option value="">--</option>${options}</select>`;
  } else {
    inner = `State/Province <input name="state" value="${value}" ${dis} placeholder="Enter region" />`;
  }
  return { wrapId, inner };
}

function interactionTypeOptions(selectedValue = '') {
  const values = Array.from(new Set([...INTERACTION_TYPE_DEFAULTS, ...(selectedValue ? [selectedValue] : [])]));
  return values
    .map((v) => `<option value="${escapeHtml(v)}" ${v === selectedValue ? 'selected' : ''}>${escapeHtml(v)}</option>`)
    .concat([`<option value="__custom__">+ Add custom…</option>`])
    .join('');
}

function bindInteractionTypeCustom(selectEl) {
  if (!selectEl) return;
  selectEl.onchange = () => {
    if (selectEl.value !== '__custom__') return;
    const custom = prompt('Enter interaction type');
    if (!custom || !custom.trim()) {
      selectEl.selectedIndex = 0;
      return;
    }
    const value = custom.trim();
    const option = document.createElement('option');
    option.value = value;
    option.textContent = value;
    option.selected = true;
    selectEl.insertBefore(option, selectEl.lastElementChild);
  };
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

async function loadMetadata() {
  const data = await api('/api/company-metadata');
  state.segments = (data.segments || []).map((x) => x.name);
  state.customerTypes = (data.types || []).map((x) => x.name);
  renderCreateCompanySelects();
}

function renderCreateCompanySelects() {
  const segmentSelect = document.getElementById('createCompanySegment');
  const typeSelect = document.getElementById('createCompanyType');
  if (!segmentSelect || !typeSelect) return;

  segmentSelect.innerHTML = `<option value="">--</option>${state.segments
    .map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`)
    .join('')}`;
  typeSelect.innerHTML = `<option value="">--</option>${state.customerTypes
    .map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`)
    .join('')}`;

  const countrySelect = document.getElementById('createCompanyCountry');
  if (countrySelect) {
    const selectedCountry = countrySelect.value || 'US';
    countrySelect.innerHTML = buildCountryOptions(selectedCountry);
    const stateField = buildStateField('create', selectedCountry, '', false);
    document.getElementById(stateField.wrapId).innerHTML = stateField.inner;
    countrySelect.onchange = () => {
      const dynamic = buildStateField('create', countrySelect.value || 'US', '', false);
      document.getElementById(dynamic.wrapId).innerHTML = dynamic.inner;
    };
  }
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
  state.companyEditMode = false;

  renderCompanyDetail();
  setView('companyDetailView', state.currentCompany.name, pushHistory);
}

function renderCompanyDetail() {
  const c = state.currentCompany;
  const isEditing = canWrite() && state.companyEditMode;
  const readOnly = isEditing ? '' : 'disabled';
  const assignedRepNames = (c.assignedReps || []).map((r) => r.full_name).join(', ') || '-';
  const mapsUrl = companyMapUrl(c);
  const segmentOptions = [`<option value="">--</option>`]
    .concat(
      state.segments.map(
        (name) => `<option value="${escapeHtml(name)}" ${c.segment === name ? 'selected' : ''}>${escapeHtml(name)}</option>`
      )
    )
    .join('');
  const typeOptions = [`<option value="">--</option>`]
    .concat(
      state.customerTypes.map(
        (name) =>
          `<option value="${escapeHtml(name)}" ${c.customer_type === name ? 'selected' : ''}>${escapeHtml(name)}</option>`
      )
    )
    .join('');

  document.getElementById('companyEditForm').innerHTML = `
    <div class="company-top-row full">
      <label>Name ${
        isEditing
          ? `<input name="name" value="${escapeHtml(c.name || '')}" ${readOnly} required />`
          : `<div class="readonly-value">${escapeHtml(c.name || '-')}</div>`
      }</label>
      <label>Main phone ${
        isEditing
          ? `<input name="mainPhone" value="${escapeHtml(c.main_phone || '')}" ${readOnly} />`
          : `<div class="readonly-value">${escapeHtml(c.main_phone || '-')}</div>`
      }</label>
    </div>
    <div class="company-box-grid full">
      <div id="companyAddressBox" class="card company-box ${isEditing ? '' : 'address-clickable'}" ${isEditing ? '' : `title="Open in Google Maps"`}>
        <strong>Address</strong>
        <div class="field-stack">
          <label>Street ${
            isEditing
              ? `<textarea name="address" rows="1" class="street-field" ${readOnly}>${escapeHtml(c.address || '')}</textarea>`
              : `<div class="readonly-value">${escapeHtml(c.address || '-')}</div>`
          }</label>
          <label>City ${
            isEditing
              ? `<input name="city" value="${escapeHtml(c.city || '')}" ${readOnly} />`
              : `<div class="readonly-value">${escapeHtml(c.city || '-')}</div>`
          }</label>
          <div class="address-row">
            <label id="companyStateWrap"></label>
            <label>Postal Code ${
              isEditing
                ? `<input name="zip" value="${escapeHtml(c.zip || '')}" ${readOnly} />`
                : `<div class="readonly-value">${escapeHtml(c.zip || '-')}</div>`
            }</label>
          </div>
          <label>Country ${
            isEditing
              ? `<select name="country" id="companyCountry" ${readOnly}>${buildCountryOptions(c.country || 'US')}</select>`
              : `<div class="readonly-value">${escapeHtml(c.country || 'US')}</div>`
          }</label>
        </div>
      </div>
      <div class="card company-box">
        <strong>Details</strong>
        <div class="field-stack">
          <label>URL ${
            isEditing
              ? `<input name="url" value="${escapeHtml(c.url || '')}" ${readOnly} />`
              : c.url
                ? `<a class="url-link" href="${escapeHtml(c.url)}" target="_blank" rel="noreferrer">${escapeHtml(c.url)}</a>`
                : `<div class="readonly-value">-</div>`
          }</label>
          <label>Segment ${
            isEditing
              ? `<select name="segment" ${readOnly}>${segmentOptions}</select>`
              : `<div class="readonly-value">${escapeHtml(c.segment || '-')}</div>`
          }</label>
          <label>Type ${
            isEditing
              ? `<select name="customerType" ${readOnly}>${typeOptions}</select>`
              : `<div class="readonly-value">${escapeHtml(c.customer_type || '-')}</div>`
          }</label>
          <label>Assigned reps ${
            isEditing
              ? `<input value="${escapeHtml(assignedRepNames)}" disabled />`
              : `<div class="readonly-value">${escapeHtml(assignedRepNames)}</div>`
          }</label>
        </div>
      </div>
      <div class="card company-box">
        <strong>Comments</strong>
        <label>Comments ${
          isEditing
            ? `<textarea name="notes" rows="6" ${readOnly}>${escapeHtml(c.notes || '')}</textarea>`
            : `<div class="readonly-value readonly-multiline">${escapeHtml(c.notes || '-')}</div>`
        }</label>
      </div>
    </div>
    <div class="card full">
      <div class="row between wrap">
        <strong>Documents</strong>
      </div>
      <div class="documents-layout">
        <div class="documents-controls">
          <input id="companyFileInput" type="file" ${readOnly} />
          <button type="button" id="uploadCompanyFileBtn" ${readOnly}>Add File</button>
        </div>
        <div id="companyFilesList" class="docs-grid"></div>
      </div>
    </div>
    <div class="row wrap full">
      ${
        canWrite()
          ? isEditing
            ? `<button type="submit">Save Company</button>
               <button type="button" id="cancelCompanyEditBtn" class="ghost">Cancel</button>
               <button type="button" id="deleteCompanyBtn" class="danger">Delete Company</button>`
            : `<button type="button" id="startCompanyEditBtn">Edit</button>`
          : ''
      }
    </div>
  `;

  const contactsBody = document.getElementById('contactsBody');
  contactsBody.innerHTML = state.companyContacts
    .map(
      (contact) => `<tr class="clickable" data-contact-id="${contact.id}">
        <td>${escapeHtml(contact.first_name)} ${escapeHtml(contact.last_name)}</td>
        <td>${
          contact.email
            ? `<a href="mailto:${encodeURIComponent(contact.email)}" class="email-link" onclick="event.stopPropagation();">${escapeHtml(
                contact.email
              )}</a>`
            : ''
        }</td>
        <td>${escapeHtml(contact.phone || '')}</td>
      </tr>`
    )
    .join('');

  const interactionsBody = document.getElementById('interactionsBody');
  interactionsBody.innerHTML = state.companyInteractions
    .map(
      (i) => `<tr class="clickable" data-interaction-id="${i.id}">
        <td>${new Date(i.created_at).toLocaleDateString()}</td>
        <td>${escapeHtml(i.created_by_name || i.rep_name || '')}</td>
        <td>${escapeHtml(i.interaction_type || '')}</td>
        <td>${escapeHtml(i.meeting_notes || '')}</td>
        <td>${escapeHtml(i.next_action || '')}${i.next_action_at ? `<br/><small>${new Date(i.next_action_at).toLocaleDateString()}</small>` : ''}</td>
      </tr>`
    )
    .join('');

  document.getElementById('newContactBtn').disabled = !canWrite();
  document.getElementById('newInteractionBtn').disabled = !canWrite();

  bindCompanyDetailEvents();
  if (isEditing) {
    const initialStateField = buildStateField('company', c.country || 'US', c.state || '', !canWrite());
    document.getElementById(initialStateField.wrapId).innerHTML = initialStateField.inner;
    const companyCountry = document.getElementById('companyCountry');
    if (companyCountry) {
      companyCountry.onchange = () => {
        const next = buildStateField('company', companyCountry.value || 'US', '', !canWrite());
        document.getElementById(next.wrapId).innerHTML = next.inner;
      };
    }
  } else {
    document.getElementById('companyStateWrap').innerHTML = `State/Province <div class="readonly-value">${escapeHtml(c.state || '-')}</div>`;
  }
  loadCompanyAttachments(c.id);
}

async function loadCompanyAttachments(companyId) {
  try {
    const data = await api(`/api/attachments?entityType=company&entityId=${companyId}`);
    document.getElementById('companyFilesList').innerHTML = data.attachments
      .map(
        (file) =>
          `<div class="doc-card">
            <div class="doc-name">
              <a href="${API_BASE}/api/files/${encodeURIComponent(file.file_key)}?token=${encodeURIComponent(
                state.token || ''
              )}" target="_blank" rel="noreferrer">${escapeHtml(file.file_name)}</a>
            </div>
            <div class="muted">${escapeHtml(file.mime_type || '')}</div>
            ${canWrite() ? `<button type="button" class="danger small-btn" data-delete-company-file="${file.id}">Delete</button>` : ''}
          </div>`
      )
      .join('');

    if (canWrite()) {
      document.querySelectorAll('[data-delete-company-file]').forEach((btn) => {
        btn.onclick = async () => {
          if (!confirm('Delete this file?')) return;
          try {
            await api(`/api/attachments/${Number(btn.dataset.deleteCompanyFile)}`, { method: 'DELETE' });
            await loadCompanyAttachments(companyId);
            showToast('File deleted');
          } catch (error) {
            showToast(error.message, true);
          }
        };
      });
    }
  } catch {
    document.getElementById('companyFilesList').innerHTML = '<div class="muted">Could not load files.</div>';
  }
}

function bindCompanyDetailEvents() {
  const form = document.getElementById('companyEditForm');
  form.onsubmit = async (event) => {
    if (!state.companyEditMode) return;
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api(`/api/companies/${state.currentCompany.id}`, {
        method: 'PUT',
        body: JSON.stringify({
          name: fd.get('name'),
          mainPhone: fd.get('mainPhone'),
          address: fd.get('address'),
          city: fd.get('city'),
          state: String(fd.get('state') || '').toUpperCase(),
          country: fd.get('country') || 'US',
          zip: fd.get('zip'),
          url: fd.get('url'),
          segment: fd.get('segment'),
          customerType: fd.get('customerType'),
          notes: fd.get('notes')
        })
      });
      await loadCompanies();
      state.companyEditMode = false;
      await openCompany(state.currentCompany.id, false);
      showToast('Company updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  const startEditBtn = document.getElementById('startCompanyEditBtn');
  if (startEditBtn) {
    startEditBtn.onclick = () => {
      state.companyEditMode = true;
      renderCompanyDetail();
    };
  }

  const addressBox = document.getElementById('companyAddressBox');
  if (addressBox && !state.companyEditMode) {
    addressBox.onclick = () => {
      window.open(companyMapUrl(state.currentCompany), '_blank', 'noopener,noreferrer');
    };
  }

  const cancelEditBtn = document.getElementById('cancelCompanyEditBtn');
  if (cancelEditBtn) {
    cancelEditBtn.onclick = () => {
      state.companyEditMode = false;
      renderCompanyDetail();
    };
  }

  const deleteCompanyBtn = document.getElementById('deleteCompanyBtn');
  if (deleteCompanyBtn) {
    deleteCompanyBtn.onclick = async () => {
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
  }

  const uploadBtn = document.getElementById('uploadCompanyFileBtn');
  if (uploadBtn) {
    uploadBtn.onclick = async () => {
      const fileInput = document.getElementById('companyFileInput');
      const file = fileInput.files?.[0];
      if (!file) {
        showToast('Choose a file first', true);
        return;
      }
      const formData = new FormData();
      formData.set('entityType', 'company');
      formData.set('entityId', String(state.currentCompany.id));
      formData.set('file', file);

      try {
        await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
        fileInput.value = '';
        await loadCompanyAttachments(state.currentCompany.id);
        showToast('File uploaded');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  }

  document.getElementById('newContactBtn').onclick = () => openContactCreate(state.currentCompany.id);
  document.getElementById('newInteractionBtn').onclick = () => openInteractionCreate(state.currentCompany.id);

  document.querySelectorAll('[data-contact-id]').forEach((row) => {
    row.onclick = () => {
      state.contactEditMode = false;
      openContactDetail(Number(row.dataset.contactId));
    };
  });

  document.querySelectorAll('[data-interaction-id]').forEach((row) => {
    row.onclick = () => openInteractionDetail(Number(row.dataset.interactionId));
  });
}

async function openContactCreate(companyId, options = {}) {
  const company = state.companies.find((c) => c.id === companyId) || state.currentCompany;
  const form = document.getElementById('contactCreateForm');
  form.innerHTML = `
    <label>Company <input value="${escapeHtml(company?.name || '')}" disabled /></label>
    <label>First name <input name="firstName" required /></label>
    <label>Last name <input name="lastName" required /></label>
    <label>Email <input name="email" type="email" /></label>
    <label>Phone <input name="phone" /></label>
    <label>Other <input name="otherPhone" /></label>
    <label class="full">Notes <textarea name="notes"></textarea></label>
    <div class="row wrap full">
      <button type="submit">Create Contact</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      const created = await api('/api/customers', {
        method: 'POST',
        body: JSON.stringify({
          companyId,
          firstName: fd.get('firstName'),
          lastName: fd.get('lastName'),
          email: fd.get('email'),
          phone: fd.get('phone'),
          otherPhone: fd.get('otherPhone'),
          notes: fd.get('notes')
        })
      });
      if (options.returnToInteraction) {
        await openInteractionCreate(companyId, options.interactionDraft || null, created.id);
      } else {
        state.contactEditMode = false;
        await openContactDetail(created.id);
      }
      showToast('Contact created');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  setView('contactCreateView', `New Contact • ${company?.name || ''}`);
}

async function openContactDetail(contactId) {
  const { customer } = await api(`/api/customers/${contactId}`);
  const isEditing = canWrite() && state.contactEditMode;
  const readOnly = isEditing ? '' : 'disabled';
  const form = document.getElementById('contactEditForm');

  form.innerHTML = `
    <div class="company-standout">${escapeHtml(customer.company_name)}</div>
    <div class="contact-top-grid-two full">
      <div class="card">
        <strong>Contact</strong>
        <div class="field-stack">
          <label>First name ${
            isEditing
              ? `<input name="firstName" value="${escapeHtml(customer.first_name)}" ${readOnly} required />`
              : `<div class="readonly-value">${escapeHtml(customer.first_name || '-')}</div>`
          }</label>
          <label>Last name ${
            isEditing
              ? `<input name="lastName" value="${escapeHtml(customer.last_name)}" ${readOnly} required />`
              : `<div class="readonly-value">${escapeHtml(customer.last_name || '-')}</div>`
          }</label>
          <label>Email ${
            isEditing
              ? `<input name="email" type="email" value="${escapeHtml(customer.email || '')}" ${readOnly} />`
              : customer.email
                ? `<a class="email-link" href="mailto:${encodeURIComponent(customer.email)}">${escapeHtml(customer.email)}</a>`
                : `<div class="readonly-value">-</div>`
          }</label>
          <label>Main phone ${
            isEditing
              ? `<input name="phone" value="${escapeHtml(customer.phone || '')}" ${readOnly} />`
              : `<div class="readonly-value">${escapeHtml(customer.phone || '-')}</div>`
          }</label>
          <label>Other phone ${
            isEditing
              ? `<input name="otherPhone" value="${escapeHtml(customer.other_phone || '')}" ${readOnly} />`
              : `<div class="readonly-value">${escapeHtml(customer.other_phone || '-')}</div>`
          }</label>
        </div>
      </div>
      <div class="card">
        <strong>Photo</strong>
        <input id="contactPhotoInput" type="file" accept="image/*" class="hidden" />
        <div id="contactPhotoTile" class="photo-tile ${isEditing && canWrite() ? 'photo-tile-editable' : ''}">
          <div id="contactPhotoPreview" class="photo-preview"></div>
        </div>
      </div>
    </div>
    <div class="contact-assets-grid full">
      <div class="card">
        <strong>Notes</strong>
        <label>Notes ${
          isEditing
            ? `<textarea name="notes" rows="8" ${readOnly}>${escapeHtml(customer.notes || '')}</textarea>`
            : `<div class="readonly-value readonly-multiline">${escapeHtml(customer.notes || '-')}</div>`
        }</label>
      </div>
      <div class="card">
        <strong>Files</strong>
        <div class="row wrap ${isEditing && canWrite() ? '' : 'hidden'}">
          <input id="contactFileInput" type="file" />
          <button id="uploadContactFileBtn" type="button">Add File</button>
        </div>
        <div id="contactFilesList" class="docs-grid"></div>
      </div>
    </div>
    <div class="row wrap full">
      ${
        canWrite()
          ? isEditing
            ? `<button type="submit">Save Contact</button>
               <button id="cancelContactEditBtn" type="button" class="ghost">Cancel</button>
               <button id="deleteContactBtn" type="button" class="danger">Delete Contact</button>`
            : `<button id="startContactEditBtn" type="button">Edit</button>`
          : ''
      }
    </div>
  `;

  form.onsubmit = async (event) => {
    if (!state.contactEditMode) return;
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
          otherPhone: fd.get('otherPhone'),
          notes: fd.get('notes'),
          photoKey: customer.photo_key || null
        })
      });
      state.contactEditMode = false;
      await openContactDetail(contactId);
      showToast('Contact updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  const delBtn = document.getElementById('deleteContactBtn');
  if (delBtn) {
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
  }

  const renderContactAssets = async () => {
    const photoContainer = document.getElementById('contactPhotoPreview');
    if (customer.photo_key) {
      photoContainer.innerHTML = `<img src="${API_BASE}/api/files/${encodeURIComponent(customer.photo_key)}?token=${encodeURIComponent(
        state.token || ''
      )}" alt="Contact photo" class="contact-photo" />`;
    } else {
      photoContainer.innerHTML = '<span class="muted">Click to add photo</span>';
    }

    try {
      const files = await api(`/api/attachments?entityType=customer&entityId=${contactId}`);
      const documentFiles = (files.attachments || []).filter((a) => a.file_key !== customer.photo_key);
      document.getElementById('contactFilesList').innerHTML = documentFiles
        .map(
          (file) => `<div class="doc-card">
            <div class="doc-name">
              <a href="${API_BASE}/api/files/${encodeURIComponent(file.file_key)}?token=${encodeURIComponent(
                state.token || ''
              )}" target="_blank" rel="noreferrer">${escapeHtml(file.file_name)}</a>
            </div>
            <div class="muted">${escapeHtml(file.mime_type || '')}</div>
            ${isEditing && canWrite() ? `<button type="button" class="danger small-btn" data-delete-contact-file="${file.id}">Delete</button>` : ''}
          </div>`
        )
        .join('');

      if (isEditing && canWrite()) {
        document.querySelectorAll('[data-delete-contact-file]').forEach((btn) => {
          btn.onclick = async () => {
            if (!confirm('Delete this file?')) return;
            try {
              await api(`/api/attachments/${Number(btn.dataset.deleteContactFile)}`, { method: 'DELETE' });
              await renderContactAssets();
              showToast('File deleted');
            } catch (error) {
              showToast(error.message, true);
            }
          };
        });
      }
    } catch {
      document.getElementById('contactFilesList').innerHTML = '<div class="muted">Could not load files.</div>';
    }
  };

  const uploadContactFileBtn = document.getElementById('uploadContactFileBtn');
  if (uploadContactFileBtn && isEditing && canWrite()) {
    uploadContactFileBtn.onclick = async () => {
      const input = document.getElementById('contactFileInput');
      const file = input.files?.[0];
      if (!file) {
        showToast('Choose a file first', true);
        return;
      }
      const formData = new FormData();
      formData.set('entityType', 'customer');
      formData.set('entityId', String(contactId));
      formData.set('file', file);
      try {
        await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
        input.value = '';
        await renderContactAssets();
        showToast('File uploaded');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  }

  const replacePhoto = async (rawFile) => {
    const processedFile = await toSquareImageFile(rawFile);
    const formData = new FormData();
    formData.set('entityType', 'customer');
    formData.set('entityId', String(contactId));
    formData.set('file', processedFile);
    const uploaded = await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
    await api(`/api/customers/${contactId}`, {
      method: 'PUT',
      body: JSON.stringify({
        companyId: customer.company_id,
        firstName: customer.first_name,
        lastName: customer.last_name,
        email: customer.email || '',
        phone: customer.phone || '',
        otherPhone: customer.other_phone || '',
        notes: customer.notes || '',
        photoKey: uploaded.key
      })
    });
    customer.photo_key = uploaded.key;
    await renderContactAssets();
    showToast('Photo updated');
  };

  const deletePhoto = async () => {
    const files = await api(`/api/attachments?entityType=customer&entityId=${contactId}`);
    const match = (files.attachments || []).find((a) => a.file_key === customer.photo_key);
    if (match) await api(`/api/attachments/${match.id}`, { method: 'DELETE' });
    await api(`/api/customers/${contactId}`, {
      method: 'PUT',
      body: JSON.stringify({
        companyId: customer.company_id,
        firstName: customer.first_name,
        lastName: customer.last_name,
        email: customer.email || '',
        phone: customer.phone || '',
        otherPhone: customer.other_phone || '',
        notes: customer.notes || '',
        photoKey: null
      })
    });
    customer.photo_key = null;
    await renderContactAssets();
    showToast('Photo deleted');
  };

  const photoInput = document.getElementById('contactPhotoInput');
  const photoTile = document.getElementById('contactPhotoTile');
  if (photoInput && photoTile && isEditing && canWrite()) {
    photoTile.onclick = async () => {
      if (!customer.photo_key) {
        photoInput.click();
        return;
      }
      const choice = await showPhotoActionDialog();
      if (choice === 'replace') {
        photoInput.click();
        return;
      }
      if (choice === 'delete') {
        try {
          await deletePhoto();
        } catch (error) {
          showToast(error.message, true);
        }
      }
    };

    photoInput.onchange = async () => {
      const file = photoInput.files?.[0];
      if (!file) return;
      try {
        await replacePhoto(file);
      } catch (error) {
        showToast(error.message, true);
      } finally {
        photoInput.value = '';
      }
    };
  }

  const startEditBtn = document.getElementById('startContactEditBtn');
  if (startEditBtn) {
    startEditBtn.onclick = () => {
      state.contactEditMode = true;
      openContactDetail(contactId);
    };
  }

  const cancelEditBtn = document.getElementById('cancelContactEditBtn');
  if (cancelEditBtn) {
    cancelEditBtn.onclick = () => {
      state.contactEditMode = false;
      openContactDetail(contactId);
    };
  }

  await renderContactAssets();
  setView('contactDetailView', `Contact • ${customer.first_name} ${customer.last_name}`);
}
async function openInteractionCreate(companyId, draft = null, selectedContactId = null) {
  const [company, customers] = await Promise.all([
    api(`/api/companies/${companyId}`),
    api(`/api/customers?companyId=${companyId}`)
  ]);
  const initial = {
    customerId: selectedContactId || draft?.customerId || '',
    interactionType: draft?.interactionType || 'Store Visit',
    meetingNotes: draft?.meetingNotes || '',
    nextAction: draft?.nextAction || '',
    nextActionAt: draft?.nextActionAt || ''
  };

  const form = document.getElementById('interactionCreateForm');
  form.innerHTML = `
    <label>Company <input value="${escapeHtml(company.company.name)}" disabled /></label>
    <label>Contact
      <select name="customerId">
        <option value="">--</option>
        <option value="__new_contact__">+ Create Contact…</option>
        ${customers.customers
          .map(
            (c) =>
              `<option value="${c.id}" ${String(initial.customerId) === String(c.id) ? 'selected' : ''}>${escapeHtml(c.first_name)} ${escapeHtml(c.last_name)}</option>`
          )
          .join('')}
      </select>
    </label>
    <label>Type
      <select name="interactionType" id="interactionCreateType">${interactionTypeOptions(initial.interactionType)}</select>
    </label>
    <label class="full">Meeting notes <textarea name="meetingNotes" required>${escapeHtml(initial.meetingNotes)}</textarea></label>
    <label class="full">Next action <input name="nextAction" value="${escapeHtml(initial.nextAction)}" /></label>
    <label class="full">Next action date <input name="nextActionAt" type="date" value="${escapeHtml(initial.nextActionAt)}" /></label>
    <label class="full">Photo <input name="photo" type="file" accept="image/*" capture="environment" /></label>
    <div class="row wrap full">
      <button type="submit">Create Interaction</button>
    </div>
  `;
  bindInteractionTypeCustom(document.getElementById('interactionCreateType'));

  form.querySelector('[name="customerId"]').onchange = async (event) => {
    if (event.target.value !== '__new_contact__') return;
    const fd = new FormData(form);
    const interactionDraft = {
      customerId: '',
      interactionType: fd.get('interactionType') || '',
      meetingNotes: fd.get('meetingNotes') || '',
      nextAction: fd.get('nextAction') || '',
      nextActionAt: fd.get('nextActionAt') || ''
    };
    await openContactCreate(companyId, { returnToInteraction: true, interactionDraft });
  };

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      const created = await api('/api/interactions', {
        method: 'POST',
        body: JSON.stringify({
          companyId,
          customerId: fd.get('customerId') ? Number(fd.get('customerId')) : null,
          repId: null,
          interactionType: fd.get('interactionType'),
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? toIsoDateStart(String(fd.get('nextActionAt'))) : null
        })
      });
      const photo = fd.get('photo');
      if (photo instanceof File && photo.size > 0) {
        const formData = new FormData();
        formData.set('entityType', 'interaction');
        formData.set('entityId', String(created.id));
        formData.set('file', photo);
        await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
      }
      await openInteractionDetail(created.id);
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
    <label>Contact
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
    <label>Editor <input value="${escapeHtml(interaction.created_by_name || '')}" disabled /></label>
    <label>Type <select name="interactionType" id="interactionDetailType" ${readOnly}>${interactionTypeOptions(interaction.interaction_type || '')}</select></label>
    <label class="full">Meeting notes <textarea name="meetingNotes" ${readOnly} required>${escapeHtml(interaction.meeting_notes || '')}</textarea></label>
    <label class="full">Next action <input name="nextAction" value="${escapeHtml(interaction.next_action || '')}" ${readOnly} /></label>
    <label class="full">Next action date <input name="nextActionAt" type="date" value="${
      interaction.next_action_at ? new Date(interaction.next_action_at).toISOString().slice(0, 10) : ''
    }" ${readOnly} /></label>
    <div class="row wrap full">
      <button type="submit" ${readOnly}>Save Interaction</button>
      <button id="deleteInteractionBtn" type="button" class="danger" ${readOnly}>Delete Interaction</button>
    </div>
  `;
  bindInteractionTypeCustom(document.getElementById('interactionDetailType'));

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      await api(`/api/interactions/${interactionId}`, {
        method: 'PUT',
        body: JSON.stringify({
          companyId: interaction.company_id,
          customerId: fd.get('customerId') ? Number(fd.get('customerId')) : null,
          repId: null,
          interactionType: fd.get('interactionType'),
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? toIsoDateStart(String(fd.get('nextActionAt'))) : null
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

  document.getElementById('repAssignmentForm').innerHTML = `
    <select name="companyId" required>
      <option value="">Select company</option>
      ${state.companies.map((c) => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('')}
    </select>
    <select name="repIds" multiple required>
      ${state.reps.map((rep) => `<option value="${rep.id}">${escapeHtml(rep.full_name)}</option>`).join('')}
    </select>
    <button type="submit">Save Company Rep Assignment</button>
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

  document.getElementById('segmentValueForm').innerHTML = `
    <strong>Segments</strong>
    <input name="name" placeholder="Add segment value" required />
    <button type="submit">Add Segment</button>
    <span class="muted">${escapeHtml(state.segments.join(', '))}</span>
  `;

  document.getElementById('typeValueForm').innerHTML = `
    <strong>Types</strong>
    <input name="name" placeholder="Add type value" required />
    <button type="submit">Add Type</button>
    <span class="muted">${escapeHtml(state.customerTypes.join(', '))}</span>
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

  const repAssignmentForm = document.getElementById('repAssignmentForm');
  repAssignmentForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(repAssignmentForm);
    const companyId = Number(fd.get('companyId'));
    const repIds = Array.from(repAssignmentForm.querySelector('[name="repIds"]').selectedOptions).map((o) => Number(o.value));
    try {
      await api(`/api/companies/${companyId}/reps`, { method: 'POST', body: JSON.stringify({ repIds }) });
      await Promise.all([renderRepsView(), loadCompanies()]);
      showToast('Company rep assignment saved');
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

  const segmentValueForm = document.getElementById('segmentValueForm');
  segmentValueForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(segmentValueForm);
    try {
      await api('/api/company-metadata/segments', { method: 'POST', body: JSON.stringify({ name: fd.get('name') }) });
      await loadMetadata();
      await renderRepsView();
      showToast('Segment added');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  const typeValueForm = document.getElementById('typeValueForm');
  typeValueForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(typeValueForm);
    try {
      await api('/api/company-metadata/types', { method: 'POST', body: JSON.stringify({ name: fd.get('name') }) });
      await loadMetadata();
      await renderRepsView();
      showToast('Type added');
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

    await Promise.all([loadCompanies(), loadReps(), loadMetadata()]);
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
  if ((previous === 'contactCreateView' || previous === 'interactionCreateView') && state.currentCompany?.id) {
    await openCompany(state.currentCompany.id, false);
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
        mainPhone: fd.get('mainPhone'),
        address: fd.get('address'),
        city: fd.get('city'),
        state: String(fd.get('state') || '').toUpperCase(),
        country: fd.get('country') || 'US',
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
