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
  segmentValues: [],
  typeValues: [],
  interactionTypeValues: [],
  theme: null,
  companyFilter: '',
  history: [],
  companyEditMode: false,
  contactEditMode: false,
  companySectionState: {},
  adminOpenSection: '',
  currentContactId: null,
  showInactiveUsers: false
};

const API_BASE = window.CRM_API_BASE || '';
const THEME_STORAGE_KEY = 'crm_theme_v1';

const VIEW_IDS = [
  'authView',
  'companyListView',
  'companyDetailView',
  'contactDetailView',
  'contactCreateView',
  'interactionDetailView',
  'interactionCreateView',
  'repsView',
  'repAccountsView'
];

const els = {
  pageTitle: document.getElementById('pageTitle'),
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
const TERRITORY_STATE_OPTIONS = [
  ['AL', 'Alabama'], ['AK', 'Alaska'], ['AZ', 'Arizona'], ['AR', 'Arkansas'], ['CA', 'California'], ['CO', 'Colorado'],
  ['CT', 'Connecticut'], ['DE', 'Delaware'], ['FL', 'Florida'], ['GA', 'Georgia'], ['HI', 'Hawaii'], ['ID', 'Idaho'],
  ['IL', 'Illinois'], ['IN', 'Indiana'], ['IA', 'Iowa'], ['KS', 'Kansas'], ['KY', 'Kentucky'], ['LA', 'Louisiana'],
  ['ME', 'Maine'], ['MD', 'Maryland'], ['MA', 'Massachusetts'], ['MI', 'Michigan'], ['MN', 'Minnesota'],
  ['MS', 'Mississippi'], ['MO', 'Missouri'], ['MT', 'Montana'], ['NE', 'Nebraska'], ['NV', 'Nevada'],
  ['NH', 'New Hampshire'], ['NJ', 'New Jersey'], ['NM', 'New Mexico'], ['NY', 'New York'], ['NC', 'North Carolina'],
  ['ND', 'North Dakota'], ['OH', 'Ohio'], ['OK', 'Oklahoma'], ['OR', 'Oregon'], ['PA', 'Pennsylvania'],
  ['RI', 'Rhode Island'], ['SC', 'South Carolina'], ['SD', 'South Dakota'], ['TN', 'Tennessee'], ['TX', 'Texas'],
  ['UT', 'Utah'], ['VT', 'Vermont'], ['VA', 'Virginia'], ['WA', 'Washington'], ['WV', 'West Virginia'], ['WI', 'Wisconsin'],
  ['WY', 'Wyoming'], ['DC', 'District of Columbia'],
  ['AB', 'Alberta'], ['BC', 'British Columbia'], ['MB', 'Manitoba'], ['NB', 'New Brunswick'], ['NL', 'Newfoundland and Labrador'],
  ['NS', 'Nova Scotia'], ['NT', 'Northwest Territories'], ['NU', 'Nunavut'], ['ON', 'Ontario'], ['PE', 'Prince Edward Island'],
  ['QC', 'Quebec'], ['SK', 'Saskatchewan'], ['YT', 'Yukon']
];
const INTERACTION_TYPE_DEFAULTS = ['Store Visit', 'Other Visit', 'Phone Call', 'Other'];
const DEFAULT_THEME = {
  bg: '#f8eef4',
  panel: '#ffffff',
  ink: '#2b1b25',
  muted: '#6a4d5d',
  line: '#e5cfdc',
  accent: '#c13a7d',
  accentSoft: '#f6deea',
  danger: '#9b234f'
};

function canWrite() {
  return ['admin', 'manager', 'rep'].includes(state.user?.role);
}

function canManageReps() {
  return ['admin', 'manager', 'owner'].includes(state.user?.role);
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

function territoryRuleText(item) {
  const scope = item.territory_type === 'city_state'
    ? `${item.city || ''}, ${item.state || ''}`.replace(/^,\s*/, '').trim()
    : item.territory_type === 'state'
      ? (item.state || '')
      : (item.zip_prefix || item.zip_exact || '');
  const core = `${item.territory_type}${item.is_exclusion ? ' (exclude)' : ''}: ${scope || '-'}`;
  const filters = `${item.segment || 'All Segments'} / ${item.customer_type || 'All Types'}`;
  return `${core} | ${filters}`;
}

function territoryRuleHtml(item, includeClass = true) {
  const text = territoryRuleText(item);
  const className = includeClass && item.is_exclusion ? 'territory-snippet territory-exclude' : 'territory-snippet';
  return `<span class="${className}">${escapeHtml(text)}</span>`;
}

function companyAddressText(company) {
  return [company.address, company.city, company.state, company.zip, company.country].filter(Boolean).join(', ');
}

function companyMapUrl(company) {
  const q = companyAddressText(company);
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(q)}`;
}

function digitsOnly(value) {
  return String(value ?? '').replace(/\D/g, '');
}

function normalizedCountryCode(country) {
  return String(country || '').trim().toUpperCase();
}

function isUsOrCa(country) {
  const code = normalizedCountryCode(country);
  return code === 'US' || code === 'CA';
}

function validatePhoneByCountry(phone, country, label = 'Phone') {
  const raw = String(phone || '').trim();
  if (!raw) return null;
  if (isUsOrCa(country) && digitsOnly(raw).length !== 10) {
    return `${label} must have exactly 10 digits for US/CA numbers.`;
  }
  return null;
}

function telHref(phone, country) {
  const raw = String(phone || '').trim();
  if (!raw) return '';
  const digits = digitsOnly(raw);
  if (!digits) return '';
  if (isUsOrCa(country)) {
    const local = digits.length === 11 && digits.startsWith('1') ? digits.slice(1) : digits;
    if (local.length === 10) return `tel:+1${local}`;
  }
  return `tel:+${digits}`;
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
    inner = `<span class="sr-only">State/Province</span><select name="state" aria-label="State/Province" ${dis}><option value="">State/Province</option>${options}</select>`;
  } else {
    inner = `<span class="sr-only">State/Province</span><input name="state" value="${value}" ${dis} placeholder="State/Province" aria-label="State/Province" />`;
  }
  return { wrapId, inner };
}

function interactionTypeOptions(selectedValue = '') {
  const configured = (state.interactionTypeValues || []).map((x) => x.name);
  const values = Array.from(new Set([...(configured.length ? configured : INTERACTION_TYPE_DEFAULTS), ...(selectedValue ? [selectedValue] : [])]));
  return values
    .map((v) => `<option value="${escapeHtml(v)}" ${v === selectedValue ? 'selected' : ''}>${escapeHtml(v)}</option>`)
    .concat([`<option value="__custom__">+ Add custom…</option>`])
    .join('');
}

function applyTheme(theme, persist = true) {
  const merged = { ...DEFAULT_THEME, ...(theme || {}) };
  const root = document.documentElement;
  root.style.setProperty('--bg', merged.bg);
  root.style.setProperty('--panel', merged.panel);
  root.style.setProperty('--ink', merged.ink);
  root.style.setProperty('--muted', merged.muted);
  root.style.setProperty('--line', merged.line);
  root.style.setProperty('--accent', merged.accent);
  root.style.setProperty('--accent-soft', merged.accentSoft);
  root.style.setProperty('--danger', merged.danger);
  state.theme = merged;
  if (persist) {
    try {
      localStorage.setItem(THEME_STORAGE_KEY, JSON.stringify(merged));
    } catch {
    }
  }
}

function copyText(value) {
  const text = String(value || '');
  if (navigator.clipboard?.writeText) return navigator.clipboard.writeText(text);
  const temp = document.createElement('textarea');
  temp.value = text;
  document.body.appendChild(temp);
  temp.select();
  document.execCommand('copy');
  temp.remove();
  return Promise.resolve();
}

function showInviteEmailDialog({ to, subject, body, mailto }) {
  const overlay = document.createElement('div');
  overlay.className = 'action-modal-overlay';
  overlay.innerHTML = `
    <div class="action-modal invite-modal">
      <h3>Send Invitation</h3>
      <p class="muted">Automatic compose is blocked by Safari. Use one of these options:</p>
      <label><span class="sr-only">To</span><input value="${escapeHtml(to)}" readonly /></label>
      <label><span class="sr-only">Subject</span><input id="inviteSubject" value="${escapeHtml(subject)}" readonly /></label>
      <label><span class="sr-only">Body</span><textarea id="inviteBody" rows="8" readonly>${escapeHtml(body)}</textarea></label>
      <div class="row wrap">
        <a class="button-link" href="${escapeHtml(mailto)}" target="_blank" rel="noreferrer">Open Email App</a>
        <button type="button" class="ghost" id="copyInviteSubjectBtn">Copy Subject</button>
        <button type="button" class="ghost" id="copyInviteBodyBtn">Copy Body</button>
        <button type="button" id="closeInviteDialogBtn">Close</button>
      </div>
    </div>
  `;
  document.body.appendChild(overlay);

  const close = () => overlay.remove();
  overlay.onclick = (event) => {
    if (event.target === overlay) close();
  };
  overlay.querySelector('#closeInviteDialogBtn').onclick = close;
  overlay.querySelector('#copyInviteSubjectBtn').onclick = async () => {
    await copyText(subject);
    showToast('Subject copied');
  };
  overlay.querySelector('#copyInviteBodyBtn').onclick = async () => {
    await copyText(body);
    showToast('Body copied');
  };
}

function buildInviteEmailPayload(adminName, email, inviteToken, temporaryPassword) {
  const baseUrl = `${window.location.origin}${window.location.pathname}`;
  const inviteUrl = `${baseUrl}?invite=${inviteToken}`;
  const subject = `Invitation from ${adminName} to access Company CRM`;
  const body = [
    'Hello, welcome to the Company CRM. By using this web application you will be able to manage companies, contacts and interactions with them easily.',
    '',
    'Copy this link to your browser to access the application and set your password:',
    inviteUrl,
    '',
    `Your user ID is your email: ${email}`,
    `Your temporary password is: ${temporaryPassword}`
  ].join('\n');
  const mailto = `mailto:${encodeURIComponent(email)}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
  return { to: email, subject, body, mailto };
}

function deriveThemeFromAccent(accent) {
  const hex = String(accent || '').replace('#', '');
  if (!/^[0-9a-fA-F]{6}$/.test(hex)) return { ...DEFAULT_THEME };
  const r = Number.parseInt(hex.slice(0, 2), 16);
  const g = Number.parseInt(hex.slice(2, 4), 16);
  const b = Number.parseInt(hex.slice(4, 6), 16);
  const tint = (amount) => {
    const mix = (v) => Math.round(v + (255 - v) * amount);
    return `#${[mix(r), mix(g), mix(b)].map((v) => v.toString(16).padStart(2, '0')).join('')}`;
  };
  return {
    bg: tint(0.9),
    panel: '#ffffff',
    ink: '#2b1b25',
    muted: '#6a4d5d',
    line: tint(0.72),
    accent: `#${hex.toLowerCase()}`,
    accentSoft: tint(0.82),
    danger: '#9b234f'
  };
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

  els.pageTitle.textContent = hint;
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
  state.segmentValues = data.segments || [];
  state.typeValues = data.types || [];
  state.interactionTypeValues = data.interactionTypes || [];
  state.segments = state.segmentValues.map((x) => x.name);
  state.customerTypes = state.typeValues.map((x) => x.name);
  renderCreateCompanySelects();
}

async function loadTheme() {
  try {
    const data = await api('/api/settings/theme');
    applyTheme(data.theme || DEFAULT_THEME);
  } catch {
    applyTheme(DEFAULT_THEME, false);
  }
}

function renderCreateCompanySelects() {
  const segmentSelect = document.getElementById('createCompanySegment');
  const typeSelect = document.getElementById('createCompanyType');
  if (!segmentSelect || !typeSelect) return;

  segmentSelect.innerHTML = `<option value="">Segment</option>${state.segments
    .map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`)
    .join('')}`;
  typeSelect.innerHTML = `<option value="">Type</option>${state.customerTypes
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
  if (!state.companySectionState[companyId]) {
    state.companySectionState[companyId] = {
      main: false,
      contacts: false,
      interactions: true
    };
  }

  renderCompanyDetail();
  setView('companyDetailView', state.currentCompany.name, pushHistory);
}

function renderCompanyDetail() {
  const c = state.currentCompany;
  const isEditing = canWrite() && state.companyEditMode;
  const readOnly = isEditing ? '' : 'disabled';
  const assignedRepNames = (c.assignedReps || []).map((r) => r.full_name).join(', ') || '-';
  const companyPhoneHref = telHref(c.main_phone || '', c.country || 'US');
  const mapsUrl = companyMapUrl(c);
  const segmentOptions = [`<option value="">Segment</option>`]
    .concat(
      state.segments.map(
        (name) => `<option value="${escapeHtml(name)}" ${c.segment === name ? 'selected' : ''}>${escapeHtml(name)}</option>`
      )
    )
    .join('');
  const typeOptions = [`<option value="">Type</option>`]
    .concat(
      state.customerTypes.map(
        (name) =>
          `<option value="${escapeHtml(name)}" ${c.customer_type === name ? 'selected' : ''}>${escapeHtml(name)}</option>`
      )
    )
    .join('');

  document.getElementById('companyEditForm').innerHTML = `
    <div class="company-top-row full">
      <label><span class="sr-only">Name</span>${
        isEditing
          ? `<input name="name" value="${escapeHtml(c.name || '')}" placeholder="Name" aria-label="Name" ${readOnly} required />`
          : `<div class="readonly-value">${escapeHtml(c.name || '-')}</div>`
      }</label>
      <label><span class="sr-only">Main phone</span>${
        isEditing
          ? `<input name="mainPhone" value="${escapeHtml(c.main_phone || '')}" placeholder="Main phone" aria-label="Main phone" ${readOnly} />`
          : c.main_phone && companyPhoneHref
            ? `<a class="phone-link" href="${companyPhoneHref}">${escapeHtml(c.main_phone)}</a>`
            : `<div class="readonly-value">${escapeHtml(c.main_phone || '-')}</div>`
      }</label>
    </div>
    <div class="company-box-grid full">
      <div id="companyAddressBox" class="card company-box ${isEditing ? '' : 'address-clickable'}" ${isEditing ? '' : `title="Open in Google Maps"`}>
        <strong>Address</strong>
        <div class="field-stack">
          <label><span class="sr-only">Street</span>${
            isEditing
              ? `<textarea name="address" rows="1" class="street-field" placeholder="Street" aria-label="Street" ${readOnly}>${escapeHtml(c.address || '')}</textarea>`
              : `<div class="readonly-value">${escapeHtml(c.address || '-')}</div>`
          }</label>
          <label><span class="sr-only">City</span>${
            isEditing
              ? `<input name="city" value="${escapeHtml(c.city || '')}" placeholder="City" aria-label="City" ${readOnly} />`
              : `<div class="readonly-value">${escapeHtml(c.city || '-')}</div>`
          }</label>
          <div class="address-row">
            <label id="companyStateWrap"></label>
            <label><span class="sr-only">Postal Code</span>${
              isEditing
                ? `<input name="zip" value="${escapeHtml(c.zip || '')}" placeholder="Postal Code" aria-label="Postal Code" ${readOnly} />`
                : `<div class="readonly-value">${escapeHtml(c.zip || '-')}</div>`
            }</label>
          </div>
          <label><span class="sr-only">Country</span>${
            isEditing
              ? `<select name="country" id="companyCountry" aria-label="Country" ${readOnly}>${buildCountryOptions(c.country || 'US')}</select>`
              : `<div class="readonly-value">${escapeHtml(c.country || 'US')}</div>`
          }</label>
        </div>
      </div>
      <div class="card company-box">
        <strong>Details</strong>
        <div class="field-stack">
          <label><span class="sr-only">URL</span>${
            isEditing
              ? `<input name="url" value="${escapeHtml(c.url || '')}" placeholder="URL" aria-label="URL" ${readOnly} />`
              : c.url
                ? `<a class="url-link" href="${escapeHtml(c.url)}" target="_blank" rel="noreferrer">${escapeHtml(c.url)}</a>`
                : `<div class="readonly-value">-</div>`
          }</label>
          <label><span class="sr-only">Segment</span>${
            isEditing
              ? `<select name="segment" aria-label="Segment" ${readOnly}>${segmentOptions}</select>`
              : `<div class="readonly-value">${escapeHtml(c.segment || '-')}</div>`
          }</label>
          <label><span class="sr-only">Type</span>${
            isEditing
              ? `<select name="customerType" aria-label="Type" ${readOnly}>${typeOptions}</select>`
              : `<div class="readonly-value">${escapeHtml(c.customer_type || '-')}</div>`
          }</label>
          <label><span class="sr-only">Assigned reps</span>${
            isEditing
              ? `<input value="${escapeHtml(assignedRepNames)}" placeholder="Assigned reps" aria-label="Assigned reps" disabled />`
              : `<div class="readonly-value">${escapeHtml(assignedRepNames)}</div>`
          }</label>
        </div>
      </div>
      <div class="card company-box">
        <strong>Comments</strong>
        <label><span class="sr-only">Comments</span>${
          isEditing
            ? `<textarea name="notes" rows="6" placeholder="Comments" aria-label="Comments" ${readOnly}>${escapeHtml(c.notes || '')}</textarea>`
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
          <input id="companyFileInput" type="file" ${canWrite() ? '' : 'disabled'} />
          <button type="button" id="uploadCompanyFileBtn" ${canWrite() ? '' : 'disabled'}>Add File</button>
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
        <td>${
          contact.phone
            ? (() => {
                const href = telHref(contact.phone, c.country || 'US');
                return href
                  ? `<a href="${href}" class="phone-link" onclick="event.stopPropagation();">${escapeHtml(contact.phone)}</a>`
                  : escapeHtml(contact.phone);
              })()
            : ''
        }</td>
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
  bindCompanySectionState();
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
    document.getElementById('companyStateWrap').innerHTML = `<span class="sr-only">State/Province</span><div class="readonly-value">${escapeHtml(c.state || '-')}</div>`;
  }
  loadCompanyAttachments(c.id);
}

function bindCompanySectionState() {
  const companyId = state.currentCompany?.id;
  if (!companyId) return;
  const current = state.companySectionState[companyId] || { main: false, contacts: false, interactions: true };

  const mainSection = document.getElementById('companyMainSection');
  const contactsSection = document.getElementById('companyContactsSection');
  const interactionsSection = document.getElementById('companyInteractionsSection');
  if (!mainSection || !contactsSection || !interactionsSection) return;

  mainSection.open = !!current.main;
  contactsSection.open = !!current.contacts;
  interactionsSection.open = !!current.interactions;

  mainSection.ontoggle = () => {
    state.companySectionState[companyId].main = mainSection.open;
  };
  contactsSection.ontoggle = () => {
    state.companySectionState[companyId].contacts = contactsSection.open;
  };
  interactionsSection.ontoggle = () => {
    state.companySectionState[companyId].interactions = interactionsSection.open;
  };
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
            ${canWrite() && state.companyEditMode ? `<button type="button" class="danger small-btn" data-delete-company-file="${file.id}">Delete</button>` : ''}
          </div>`
      )
      .join('');

    if (canWrite() && state.companyEditMode) {
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
      const country = String(fd.get('country') || 'US').toUpperCase();
      const mainPhoneError = validatePhoneByCountry(fd.get('mainPhone'), country, 'Main phone');
      if (mainPhoneError) throw new Error(mainPhoneError);
      await api(`/api/companies/${state.currentCompany.id}`, {
        method: 'PUT',
        body: JSON.stringify({
          name: fd.get('name'),
          mainPhone: fd.get('mainPhone'),
          address: fd.get('address'),
          city: fd.get('city'),
          state: String(fd.get('state') || '').toUpperCase(),
          country,
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
  const companyCountry = company?.country || 'US';
  const form = document.getElementById('contactCreateForm');
  form.innerHTML = `
    <label><span class="sr-only">Company</span><input value="${escapeHtml(company?.name || '')}" placeholder="Company" aria-label="Company" disabled /></label>
    <label><span class="sr-only">First name</span><input name="firstName" placeholder="First name" aria-label="First name" required /></label>
    <label><span class="sr-only">Last name</span><input name="lastName" placeholder="Last name" aria-label="Last name" required /></label>
    <label><span class="sr-only">Email</span><input name="email" type="email" placeholder="Email" aria-label="Email" /></label>
    <label><span class="sr-only">Main phone</span><input name="phone" placeholder="Main phone" aria-label="Main phone" /></label>
    <label><span class="sr-only">Other phone</span><input name="otherPhone" placeholder="Other phone" aria-label="Other phone" /></label>
    <label class="full"><span class="sr-only">Notes</span><textarea name="notes" placeholder="Notes" aria-label="Notes"></textarea></label>
    <div class="row wrap full">
      <button type="submit">Create Contact</button>
    </div>
  `;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    try {
      const phoneError = validatePhoneByCountry(fd.get('phone'), companyCountry, 'Main phone');
      if (phoneError) throw new Error(phoneError);
      const otherPhoneError = validatePhoneByCountry(fd.get('otherPhone'), companyCountry, 'Other phone');
      if (otherPhoneError) throw new Error(otherPhoneError);
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
  state.currentContactId = contactId;
  const { customer } = await api(`/api/customers/${contactId}`);
  const contactCompany = state.companies.find((c) => c.id === customer.company_id) || state.currentCompany;
  const contactCountry = contactCompany?.country || 'US';
  const contactPhoneHref = telHref(customer.phone || '', contactCountry);
  const contactOtherPhoneHref = telHref(customer.other_phone || '', contactCountry);
  const isEditing = canWrite() && state.contactEditMode;
  const readOnly = isEditing ? '' : 'disabled';
  const form = document.getElementById('contactEditForm');

  form.innerHTML = `
    <div class="company-standout">${escapeHtml(customer.company_name)}</div>
    <div class="contact-top-grid-two full">
      <div class="card">
        <strong>Contact</strong>
        <div class="field-stack">
          ${
            isEditing
              ? `<label><span class="sr-only">First name</span><input name="firstName" value="${escapeHtml(
                  customer.first_name
                )}" placeholder="First name" aria-label="First name" ${readOnly} required /></label>
                 <label><span class="sr-only">Last name</span><input name="lastName" value="${escapeHtml(
                   customer.last_name
                 )}" placeholder="Last name" aria-label="Last name" ${readOnly} required /></label>`
              : `<div class="name-row">
                   <div class="readonly-value">${escapeHtml(customer.first_name || '-')}</div>
                   <div class="readonly-value">${escapeHtml(customer.last_name || '-')}</div>
                 </div>`
          }
          <label><span class="sr-only">Email</span>${
            isEditing
              ? `<input name="email" type="email" value="${escapeHtml(customer.email || '')}" placeholder="Email" aria-label="Email" ${readOnly} />`
              : customer.email
                ? `<a class="email-link" href="mailto:${encodeURIComponent(customer.email)}">${escapeHtml(customer.email)}</a>`
                : `<div class="readonly-value">-</div>`
          }</label>
          <label><span class="sr-only">Main phone</span>${
            isEditing
              ? `<input name="phone" value="${escapeHtml(customer.phone || '')}" placeholder="Main phone" aria-label="Main phone" ${readOnly} />`
              : customer.phone && contactPhoneHref
                ? `<a class="phone-link" href="${contactPhoneHref}">${escapeHtml(customer.phone)}</a>`
                : `<div class="readonly-value">${escapeHtml(customer.phone || '-')}</div>`
          }</label>
          <label><span class="sr-only">Other phone</span>${
            isEditing
              ? `<input name="otherPhone" value="${escapeHtml(customer.other_phone || '')}" placeholder="Other phone" aria-label="Other phone" ${readOnly} />`
              : customer.other_phone && contactOtherPhoneHref
                ? `<a class="phone-link" href="${contactOtherPhoneHref}">${escapeHtml(customer.other_phone)}</a>`
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
        <label><span class="sr-only">Notes</span>${
          isEditing
            ? `<textarea name="notes" rows="8" placeholder="Notes" aria-label="Notes" ${readOnly}>${escapeHtml(customer.notes || '')}</textarea>`
            : `<div class="readonly-value readonly-multiline">${escapeHtml(customer.notes || '-')}</div>`
        }</label>
      </div>
      <div class="card">
        <strong>Files</strong>
        <div class="row wrap ${canWrite() ? '' : 'hidden'}">
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
      const phoneError = validatePhoneByCountry(fd.get('phone'), contactCountry, 'Main phone');
      if (phoneError) throw new Error(phoneError);
      const otherPhoneError = validatePhoneByCountry(fd.get('otherPhone'), contactCountry, 'Other phone');
      if (otherPhoneError) throw new Error(otherPhoneError);
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
  if (uploadContactFileBtn && canWrite()) {
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
  if (photoInput && photoTile && canWrite()) {
    photoTile.onclick = async () => {
      if (!customer.photo_key || !isEditing) {
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
  setView('contactDetailView', `${customer.first_name} ${customer.last_name}`);
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
    <div class="interaction-layout full">
      <div class="interaction-left-stack">
        <div class="card">
          <div class="field-stack">
            <label><span class="sr-only">Company</span><input value="${escapeHtml(
              company.company.name
            )}" placeholder="Company" aria-label="Company" disabled /></label>
            <label><span class="sr-only">Contact</span>
              <select name="customerId" aria-label="Contact">
                <option value="">Contact</option>
                <option value="__new_contact__">+ Create Contact…</option>
                ${customers.customers
                  .map(
                    (c) =>
                      `<option value="${c.id}" ${String(initial.customerId) === String(c.id) ? 'selected' : ''}>${escapeHtml(c.first_name)} ${escapeHtml(c.last_name)}</option>`
                  )
                  .join('')}
              </select>
            </label>
            <label><span class="sr-only">Type</span>
              <select name="interactionType" id="interactionCreateType" aria-label="Type">${interactionTypeOptions(
                initial.interactionType
              )}</select>
            </label>
          </div>
        </div>
        <div class="card">
          <strong>Meeting Notes</strong>
          <label><span class="sr-only">Meeting notes</span><textarea name="meetingNotes" placeholder="Meeting notes" aria-label="Meeting notes" required>${escapeHtml(
            initial.meetingNotes
          )}</textarea></label>
          <label><span class="sr-only">Next action</span><input name="nextAction" placeholder="Next action" aria-label="Next action" value="${escapeHtml(
            initial.nextAction
          )}" /></label>
          <label><span class="sr-only">Next action date</span><input name="nextActionAt" type="date" aria-label="Next action date" value="${escapeHtml(
            initial.nextActionAt
          )}" /></label>
        </div>
      </div>
      <div class="interaction-right-stack">
        <div class="card">
          <strong>Photo</strong>
          <input id="interactionCreatePhotoInput" name="photo" type="file" accept="image/*" capture="environment" class="hidden" />
          <div id="interactionCreatePhotoTile" class="photo-tile photo-tile-editable">
            <div id="interactionCreatePhotoPreview" class="photo-preview"><span class="muted">Click to add photo</span></div>
          </div>
        </div>
      </div>
    </div>
    <div class="row wrap full">
      <button type="submit">Create Interaction</button>
    </div>
  `;
  bindInteractionTypeCustom(document.getElementById('interactionCreateType'));

  const createPhotoInput = document.getElementById('interactionCreatePhotoInput');
  const createPhotoTile = document.getElementById('interactionCreatePhotoTile');
  const createPhotoPreview = document.getElementById('interactionCreatePhotoPreview');
  if (createPhotoInput && createPhotoTile && createPhotoPreview) {
    createPhotoTile.onclick = () => createPhotoInput.click();
    createPhotoInput.onchange = () => {
      const file = createPhotoInput.files?.[0];
      if (!file) return;
      const previewUrl = URL.createObjectURL(file);
      createPhotoPreview.innerHTML = `<img src="${previewUrl}" alt="Interaction photo preview" class="contact-photo" />`;
    };
  }

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
        const processedPhoto = await toSquareImageFile(photo);
        const formData = new FormData();
        formData.set('entityType', 'interaction');
        formData.set('entityId', String(created.id));
        formData.set(
          'file',
          new File([processedPhoto], `interaction-photo-${Date.now()}.jpg`, {
            type: processedPhoto.type || 'image/jpeg'
          })
        );
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
    <div class="interaction-layout full">
      <div class="interaction-left-stack">
        <div class="card">
          <div class="field-stack">
            <label><span class="sr-only">Company</span><input value="${escapeHtml(
              interaction.company_name
            )}" placeholder="Company" aria-label="Company" disabled /></label>
            <label><span class="sr-only">Contact</span>
              <select name="customerId" aria-label="Contact" ${readOnly}>
                <option value="">Contact</option>
                ${companyCustomers.customers
                  .map(
                    (c) =>
                      `<option value="${c.id}" ${interaction.customer_id === c.id ? 'selected' : ''}>${escapeHtml(c.first_name)} ${escapeHtml(c.last_name)}</option>`
                  )
                  .join('')}
              </select>
            </label>
            <label><span class="sr-only">Editor</span><input value="${escapeHtml(
              interaction.created_by_name || ''
            )}" placeholder="Editor" aria-label="Editor" disabled /></label>
            <label><span class="sr-only">Type</span><select name="interactionType" id="interactionDetailType" aria-label="Type" ${readOnly}>${interactionTypeOptions(
              interaction.interaction_type || ''
            )}</select></label>
          </div>
        </div>
        <div class="card">
          <strong>Meeting Notes</strong>
          <label><span class="sr-only">Meeting notes</span><textarea name="meetingNotes" placeholder="Meeting notes" aria-label="Meeting notes" ${readOnly} required>${escapeHtml(
            interaction.meeting_notes || ''
          )}</textarea></label>
          <label><span class="sr-only">Next action</span><input name="nextAction" placeholder="Next action" aria-label="Next action" value="${escapeHtml(
            interaction.next_action || ''
          )}" ${readOnly} /></label>
          <label><span class="sr-only">Next action date</span><input name="nextActionAt" type="date" aria-label="Next action date" value="${
            interaction.next_action_at ? new Date(interaction.next_action_at).toISOString().slice(0, 10) : ''
          }" ${readOnly} /></label>
        </div>
      </div>
      <div class="interaction-right-stack">
        <div class="card">
          <strong>Photo</strong>
          <input id="interactionPhotoInput" type="file" accept="image/*" capture="environment" class="hidden" />
          <div id="interactionPhotoTile" class="photo-tile ${canWrite() ? 'photo-tile-editable' : ''}">
            <div id="interactionPhotoPreview" class="photo-preview"></div>
          </div>
        </div>
        <div class="card">
          <strong>Files</strong>
          <div class="row wrap ${canWrite() ? '' : 'hidden'}">
            <input id="interactionFileInput" type="file" />
            <button id="uploadInteractionFileBtn" type="button">Add File</button>
          </div>
          <div id="interactionFilesList" class="docs-grid"></div>
        </div>
      </div>
    </div>
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

  const renderInteractionAssets = async () => {
    try {
      const files = await api(`/api/attachments?entityType=interaction&entityId=${interactionId}`);
      const attachments = files.attachments || [];
      const photo = attachments.find((a) => (a.file_name || '').startsWith('interaction-photo-')) ||
        attachments.find((a) => String(a.mime_type || '').toLowerCase().startsWith('image/'));
      const photoKey = photo?.file_key || null;

      const photoContainer = document.getElementById('interactionPhotoPreview');
      if (photoKey) {
        photoContainer.innerHTML = `<img src="${API_BASE}/api/files/${encodeURIComponent(photoKey)}?token=${encodeURIComponent(
          state.token || ''
        )}" alt="Interaction photo" class="contact-photo" />`;
      } else {
        photoContainer.innerHTML = '<span class="muted">Click to add photo</span>';
      }

      const docs = attachments.filter((a) => a.file_key !== photoKey);
      document.getElementById('interactionFilesList').innerHTML = docs
        .map(
          (file) => `<div class="doc-card">
            <div class="doc-name">
              <a href="${API_BASE}/api/files/${encodeURIComponent(file.file_key)}?token=${encodeURIComponent(
                state.token || ''
              )}" target="_blank" rel="noreferrer">${escapeHtml(file.file_name)}</a>
            </div>
            <div class="muted">${escapeHtml(file.mime_type || '')}</div>
            ${
              canWrite()
                ? `<button type="button" class="danger small-btn" data-delete-interaction-file="${file.id}">Delete</button>`
                : ''
            }
          </div>`
        )
        .join('');

      if (canWrite()) {
        document.querySelectorAll('[data-delete-interaction-file]').forEach((btn) => {
          btn.onclick = async () => {
            if (!confirm('Delete this file?')) return;
            try {
              await api(`/api/attachments/${Number(btn.dataset.deleteInteractionFile)}`, { method: 'DELETE' });
              await renderInteractionAssets();
              showToast('File deleted');
            } catch (error) {
              showToast(error.message, true);
            }
          };
        });
      }
    } catch {
      document.getElementById('interactionPhotoPreview').innerHTML = '<span class="muted">Could not load photo.</span>';
      document.getElementById('interactionFilesList').innerHTML = '<div class="muted">Could not load files.</div>';
    }
  };

  const interactionPhotoTile = document.getElementById('interactionPhotoTile');
  const interactionPhotoInput = document.getElementById('interactionPhotoInput');
  if (interactionPhotoTile && interactionPhotoInput && canWrite()) {
    interactionPhotoTile.onclick = () => interactionPhotoInput.click();
    interactionPhotoInput.onchange = async () => {
      const rawFile = interactionPhotoInput.files?.[0];
      if (!rawFile) return;
      try {
        const processedFile = await toSquareImageFile(rawFile);
        const formData = new FormData();
        formData.set('entityType', 'interaction');
        formData.set('entityId', String(interactionId));
        formData.set(
          'file',
          new File([processedFile], `interaction-photo-${Date.now()}.jpg`, { type: processedFile.type || 'image/jpeg' })
        );
        await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
        await renderInteractionAssets();
        showToast('Photo uploaded');
      } catch (error) {
        showToast(error.message, true);
      } finally {
        interactionPhotoInput.value = '';
      }
    };
  }

  const uploadInteractionFileBtn = document.getElementById('uploadInteractionFileBtn');
  if (uploadInteractionFileBtn && canWrite()) {
    uploadInteractionFileBtn.onclick = async () => {
      const input = document.getElementById('interactionFileInput');
      const file = input.files?.[0];
      if (!file) {
        showToast('Choose a file first', true);
        return;
      }
      const formData = new FormData();
      formData.set('entityType', 'interaction');
      formData.set('entityId', String(interactionId));
      formData.set('file', file);
      try {
        await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
        input.value = '';
        await renderInteractionAssets();
        showToast('File uploaded');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  }

  await renderInteractionAssets();

  setView('interactionDetailView', `Interaction • ${interaction.company_name}`);
}

async function renderRepsView() {
  const data = await api('/api/reps/with-assignments');
  state.reps = data.reps;
  state.repAssignments = data.assignments;
  state.repTerritories = data.territories;
  const isAdmin = state.user?.role === 'admin';
  let users = [];
  if (isAdmin) {
    try {
      const usersData = await api('/api/users');
      users = usersData.users || [];
    } catch {
      users = [];
    }
  }

  document.getElementById('themeForm').innerHTML = `
    <label><span class="sr-only">Primary color</span><input name="accent" type="color" value="${escapeHtml(
      state.theme?.accent || DEFAULT_THEME.accent
    )}" aria-label="Primary color" /></label>
    <button type="submit">Save Theme</button>
  `;

  document.getElementById('interactionTypeValueForm').innerHTML = `
    <input name="name" placeholder="Add meeting type" required />
    <button type="submit">Add Meeting Type</button>
  `;
  document.getElementById('interactionTypeList').innerHTML = (state.interactionTypeValues || [])
    .map(
      (item) => `<li>
        <span>${escapeHtml(item.name)}</span>
        <button type="button" class="ghost" title="Edit" aria-label="Edit" data-rename-interaction-type="${item.id}">✎</button>
      </li>`
    )
    .join('');

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
      const territoryPreview = territories.slice(0, 2).map((item) => territoryRuleHtml(item)).join('');
      const territoryMore = territories.length > 2 ? `<div class="tiny">+${territories.length - 2} more</div>` : '';
      return `<tr class="clickable" data-open-rep-detail="${rep.id}">
        <td>${escapeHtml(rep.full_name)}</td>
        <td>${escapeHtml(rep.email || '')}</td>
        <td>${escapeHtml(rep.phone || '')}</td>
        <td>${rep.last_entry_at ? new Date(rep.last_entry_at).toLocaleDateString() : '-'}</td>
        <td>${escapeHtml(companies.join(', ') || '-')}</td>
        <td class="territory-cell">
          ${territories.length ? `${territoryPreview}${territoryMore}` : '<span class="tiny">No territories assigned</span>'}
          <div><button class="ghost" data-show-territories="${rep.id}">View Rules (${territories.length})</button></div>
        </td>
      </tr>`;
    })
    .join('');

  document.getElementById('territoryForm').innerHTML = `
    <select name="repId" required>
      <option value="">Rep</option>
      ${state.reps.map((rep) => `<option value="${rep.id}">${escapeHtml(rep.full_name)}</option>`).join('')}
    </select>
    <select name="segment">
      <option value="">All Segments</option>
      ${state.segments.map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`).join('')}
    </select>
    <select name="customerType">
      <option value="">All Types</option>
      ${state.customerTypes.map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`).join('')}
    </select>
    <select name="territoryType" required>
      <option value="state">State</option>
      <option value="city_state">City + State</option>
      <option value="zip_prefix">Zip Prefix</option>
      <option value="zip_exact">Zip Exact</option>
    </select>
    <textarea name="bulkValues" rows="2" placeholder="Bulk values (comma/new line). Use -prefix or -zip to exclude."></textarea>
    <select name="state">
      <option value="">State/Province</option>
      ${TERRITORY_STATE_OPTIONS.map(([code, name]) => `<option value="${code}">${code} - ${name}</option>`).join('')}
    </select>
    <input name="city" placeholder="City" />
    <input name="zipPrefix" placeholder="Zip prefix (e.g. 901 or -901)" />
    <input name="zipExact" placeholder="Zip exact (e.g. 90210 or -90210)" />
    <button type="submit">Add Territory</button>
  `;

  document.getElementById('segmentValueForm').innerHTML = `
    <strong>Segments</strong>
    <input name="name" placeholder="Add segment value" required />
    <button type="submit">Add</button>
  `;
  document.getElementById('segmentValueList').innerHTML = (state.segmentValues || [])
    .map(
      (item) => `<li>
        <span>${escapeHtml(item.name)}</span>
        <button type="button" class="ghost" title="Edit" aria-label="Edit" data-rename-segment="${item.id}">✎</button>
        <button type="button" class="danger small-btn" title="Delete" aria-label="Delete" data-delete-segment="${item.id}">⌦</button>
      </li>`
    )
    .join('');

  document.getElementById('typeValueForm').innerHTML = `
    <strong>Types</strong>
    <input name="name" placeholder="Add type value" required />
    <button type="submit">Add</button>
  `;
  document.getElementById('typeValueList').innerHTML = (state.typeValues || [])
    .map(
      (item) => `<li>
        <span>${escapeHtml(item.name)}</span>
        <button type="button" class="ghost" title="Edit" aria-label="Edit" data-rename-type="${item.id}">✎</button>
        <button type="button" class="danger small-btn" title="Delete" aria-label="Delete" data-delete-type="${item.id}">⌦</button>
      </li>`
    )
    .join('');

  const userCard = document.getElementById('userAdminCard');
  userCard.classList.toggle('hidden', !isAdmin);
  if (isAdmin) {
    document.getElementById('userCreateForm').innerHTML = `
      <input name="fullName" placeholder="Full name" required />
      <input name="email" placeholder="Email" type="email" required />
      <select name="role" required>
        <option value="viewer">Viewer</option>
        <option value="rep">Rep</option>
        <option value="manager">Manager</option>
        <option value="admin">Admin</option>
      </select>
      <button type="submit">Create User</button>
    `;
    const visibleUsers = users.filter((u) => (state.showInactiveUsers ? !u.is_active : !!u.is_active));
    const toggle = document.getElementById('showInactiveUsersToggle');
    if (toggle) toggle.checked = !!state.showInactiveUsers;
    document.getElementById('usersBody').innerHTML = visibleUsers
      .map(
        (u) => `<tr>
          <td>${escapeHtml(u.full_name)}</td>
          <td>${escapeHtml(u.email)}</td>
          <td>
            <select class="user-role-select" data-user-role="${u.id}">
              <option value="viewer" ${u.role === 'viewer' ? 'selected' : ''}>viewer</option>
              <option value="rep" ${u.role === 'rep' ? 'selected' : ''}>rep</option>
              <option value="manager" ${u.role === 'manager' ? 'selected' : ''}>manager</option>
              <option value="admin" ${u.role === 'admin' ? 'selected' : ''}>admin</option>
            </select>
          </td>
          <td>${u.last_login_at ? new Date(u.last_login_at).toLocaleDateString() : '-'}</td>
          <td class="user-active-cell"><input class="user-active-checkbox" type="checkbox" data-user-active="${u.id}" ${u.is_active ? 'checked' : ''} /></td>
          <td class="row user-actions">
            <button type="button" class="ghost" title="Edit" aria-label="Edit" data-edit-user="${u.id}">✎</button>
            <button type="button" class="danger small-btn" title="Delete" aria-label="Delete" data-delete-user="${u.id}">⌦</button>
            <button type="button" class="ghost" data-resend-user="${u.id}">Resend</button>
          </td>
        </tr>`
      )
      .join('');
  } else {
    document.getElementById('userCreateForm').innerHTML = '';
    document.getElementById('usersBody').innerHTML = '';
  }

  bindRepsEvents();
  setView('repsView', 'Admin Panel');
}

function bindRepsEvents() {
  document.querySelectorAll('#repsView .admin-section').forEach((section) => {
    const key = section.querySelector('summary')?.textContent?.trim() || '';
    section.open = key === state.adminOpenSection;
    section.ontoggle = () => {
      if (!section.open) return;
      state.adminOpenSection = key;
      document.querySelectorAll('#repsView .admin-section').forEach((other) => {
        if (other !== section) other.open = false;
      });
    };
  });

  const themeForm = document.getElementById('themeForm');
  themeForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(themeForm);
    const accent = String(fd.get('accent') || DEFAULT_THEME.accent);
    const theme = deriveThemeFromAccent(accent);
    try {
      await api('/api/settings/theme', { method: 'PUT', body: JSON.stringify({ accent }) });
      applyTheme(theme);
      showToast('Theme updated');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  themeForm.querySelector('[name="accent"]').oninput = (event) => {
    applyTheme(deriveThemeFromAccent(event.target.value), false);
  };

  const interactionTypeValueForm = document.getElementById('interactionTypeValueForm');
  interactionTypeValueForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(interactionTypeValueForm);
    try {
      await api('/api/interaction-types', { method: 'POST', body: JSON.stringify({ name: fd.get('name') }) });
      await loadMetadata();
      await renderRepsView();
      showToast('Meeting type added');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  document.querySelectorAll('[data-rename-interaction-type]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.renameInteractionType);
      const current = state.interactionTypeValues.find((x) => x.id === id);
      const next = prompt('Rename meeting type', current?.name || '');
      if (!next || !next.trim()) return;
      try {
        await api(`/api/interaction-types/${id}`, { method: 'PATCH', body: JSON.stringify({ name: next.trim() }) });
        await loadMetadata();
        await renderRepsView();
        showToast('Meeting type renamed');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

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
    btn.onclick = (event) => {
      event.stopPropagation();
      const repId = Number(btn.dataset.showTerritories);
      const items = state.repTerritories.filter((t) => t.rep_id === repId);
      document.getElementById('territoryList').innerHTML = items
        .map(
          (item) => `<li>
            ${territoryRuleHtml(item)}
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
    const territoryType = String(fd.get('territoryType') || '');
    const bulkRaw = String(fd.get('bulkValues') || '')
      .split(/[\n,]/g)
      .map((part) => part.trim())
      .filter(Boolean);
    const payload = {
      repId: Number(fd.get('repId')),
      territoryType,
      state: fd.get('state'),
      city: fd.get('city'),
      zipPrefix: fd.get('zipPrefix'),
      zipExact: fd.get('zipExact'),
      segment: fd.get('segment'),
      customerType: fd.get('customerType')
    };
    if (bulkRaw.length > 0) {
      if (territoryType === 'state') payload.states = bulkRaw;
      if (territoryType === 'zip_prefix') payload.zipPrefixes = bulkRaw;
      if (territoryType === 'zip_exact') payload.zipExacts = bulkRaw;
      if (territoryType === 'city_state') payload.cityStates = bulkRaw
        .map((entry) => {
          const parts = entry.split(',').map((x) => x.trim());
          if (parts.length < 2) return null;
          const state = parts.pop();
          const city = parts.join(', ');
          if (!city || !state) return null;
          return { city, state };
        })
        .filter(Boolean);
    }
    try {
      await api('/api/rep-territories', {
        method: 'POST',
        body: JSON.stringify(payload)
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
  document.querySelectorAll('[data-rename-segment]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.renameSegment);
      const current = state.segmentValues.find((x) => x.id === id);
      const next = prompt('Rename segment', current?.name || '');
      if (!next || !next.trim()) return;
      try {
        await api(`/api/company-metadata/segments/${id}`, { method: 'PATCH', body: JSON.stringify({ name: next.trim() }) });
        await loadMetadata();
        await Promise.all([loadCompanies(), renderRepsView()]);
        showToast('Segment renamed');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });
  document.querySelectorAll('[data-delete-segment]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.deleteSegment);
      if (!confirm('Delete this segment? Existing records will keep working but become unassigned.')) return;
      try {
        await api(`/api/company-metadata/segments/${id}`, { method: 'DELETE' });
        await loadMetadata();
        await Promise.all([loadCompanies(), renderRepsView()]);
        showToast('Segment deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

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
  document.querySelectorAll('[data-rename-type]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.renameType);
      const current = state.typeValues.find((x) => x.id === id);
      const next = prompt('Rename type', current?.name || '');
      if (!next || !next.trim()) return;
      try {
        await api(`/api/company-metadata/types/${id}`, { method: 'PATCH', body: JSON.stringify({ name: next.trim() }) });
        await loadMetadata();
        await Promise.all([loadCompanies(), renderRepsView()]);
        showToast('Type renamed');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });
  document.querySelectorAll('[data-delete-type]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.deleteType);
      if (!confirm('Delete this type? Existing records will keep working but become unassigned.')) return;
      try {
        await api(`/api/company-metadata/types/${id}`, { method: 'DELETE' });
        await loadMetadata();
        await Promise.all([loadCompanies(), renderRepsView()]);
        showToast('Type deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

  document.querySelectorAll('[data-open-rep-detail]').forEach((row) => {
    row.onclick = () => {
      const repId = Number(row.dataset.openRepDetail);
      openRepAccounts(repId);
    };
  });

  const userCreateForm = document.getElementById('userCreateForm');
  if (userCreateForm && state.user?.role === 'admin') {
    userCreateForm.onsubmit = async (event) => {
      event.preventDefault();
      const fd = new FormData(userCreateForm);
      try {
        const created = await api('/api/users', {
          method: 'POST',
          body: JSON.stringify({
            fullName: fd.get('fullName'),
            email: fd.get('email'),
            role: fd.get('role')
          })
        });
        const payload = buildInviteEmailPayload(
          state.user.fullName,
          String(fd.get('email') || ''),
          created.inviteToken,
          created.temporaryPassword
        );
        showInviteEmailDialog(payload);
        await renderRepsView();
        showToast('User created. Invitation ready.');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  }

  const showInactiveUsersToggle = document.getElementById('showInactiveUsersToggle');
  if (showInactiveUsersToggle && state.user?.role === 'admin') {
    showInactiveUsersToggle.onchange = async () => {
      state.showInactiveUsers = !state.showInactiveUsers;
      await renderRepsView();
    };
  }

  document.querySelectorAll('[data-edit-user]').forEach((btn) => {
    btn.onclick = async () => {
      const userId = Number(btn.dataset.editUser);
      const roleEl = document.querySelector(`[data-user-role="${userId}"]`);
      const activeEl = document.querySelector(`[data-user-active="${userId}"]`);
      if (!roleEl || !activeEl) return;
      const row = btn.closest('tr');
      const currentName = row?.children?.[0]?.textContent?.trim() || '';
      const currentEmail = row?.children?.[1]?.textContent?.trim() || '';
      const nextName = prompt('Full name', currentName);
      if (!nextName || !nextName.trim()) return;
      const nextEmail = prompt('Email', currentEmail);
      if (!nextEmail || !nextEmail.trim()) return;
      try {
        await api(`/api/users/${userId}`, {
          method: 'PATCH',
          body: JSON.stringify({
            role: roleEl.value,
            isActive: !!activeEl.checked,
            fullName: nextName.trim(),
            email: nextEmail.trim()
          })
        });
        await renderRepsView();
        showToast('User updated');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

  document.querySelectorAll('[data-delete-user]').forEach((btn) => {
    btn.onclick = async () => {
      const userId = Number(btn.dataset.deleteUser);
      if (!confirm('Delete this user? This will deactivate access.')) return;
      try {
        await api(`/api/users/${userId}`, { method: 'DELETE' });
        await renderRepsView();
        showToast('User deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

  document.querySelectorAll('[data-resend-user]').forEach((btn) => {
    btn.onclick = async () => {
      const userId = Number(btn.dataset.resendUser);
      try {
        const invite = await api(`/api/users/${userId}/resend-invite`, { method: 'POST' });
        const payload = buildInviteEmailPayload(
          state.user.fullName,
          invite.email,
          invite.inviteToken,
          invite.temporaryPassword
        );
        showInviteEmailDialog(payload);
        showToast('Invitation regenerated');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });
}

function openRepAccounts(repId) {
  const rep = state.reps.find((r) => r.id === repId);
  const companies = state.repAssignments.filter((a) => a.rep_id === repId);
  const territories = state.repTerritories.filter((t) => t.rep_id === repId);
  document.getElementById('repAccountsTitle').textContent = `Accounts • ${rep?.full_name || ''}`;
  document.getElementById('repTerritorySummary').innerHTML = territories.length
    ? territories.map((item) => `<li>${territoryRuleHtml(item)}</li>`).join('')
    : '<li class="tiny">No territories assigned</li>';
  document.getElementById('repAccountsBody').innerHTML = companies.length
    ? companies
        .map(
          (c) => `<tr class="clickable" data-open-company-from-rep="${c.company_id}">
            <td>${escapeHtml(c.company_name)}</td>
            <td>${escapeHtml(c.city || '')}</td>
            <td>${escapeHtml(c.state || '')}</td>
            <td>${escapeHtml(c.zip || '')}</td>
          </tr>`
        )
        .join('')
    : '<tr><td colspan="4">No assigned companies.</td></tr>';

  document.querySelectorAll('[data-open-company-from-rep]').forEach((row) => {
    row.onclick = () => openCompany(Number(row.dataset.openCompanyFromRep));
  });
  setView('repAccountsView', `Accounts • ${rep?.full_name || ''}`);
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

    await Promise.all([loadCompanies(), loadReps(), loadMetadata(), loadTheme()]);
    setView('companyListView', 'Company list', false);
  } catch {
    localStorage.removeItem('crm_token');
    state.token = null;
    setView('authView', 'Sign in', false);
  }
}

function initInviteSetupForm() {
  const form = document.getElementById('inviteSetupForm');
  const loginForm = document.getElementById('loginForm');
  const bootstrapForm = document.getElementById('bootstrapForm');
  const url = new URL(window.location.href);
  const inviteToken = url.searchParams.get('invite');

  if (!inviteToken) {
    form.classList.add('hidden');
    loginForm.classList.remove('hidden');
    bootstrapForm.classList.add('hidden');
    return;
  }

  form.classList.remove('hidden');
  loginForm.classList.add('hidden');
  bootstrapForm.classList.add('hidden');
  form.querySelector('[name="email"]').value = '';

  api(`/api/auth/invite/${encodeURIComponent(inviteToken)}`)
    .then((data) => {
      form.querySelector('[name="email"]').value = data.email || '';
    })
    .catch((error) => {
      showToast(error.message, true);
    });

  form.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(form);
    const password = String(fd.get('password') || '');
    const confirmPassword = String(fd.get('confirmPassword') || '');
    if (password !== confirmPassword) {
      showToast('Passwords do not match', true);
      return;
    }
    try {
      await api('/api/auth/invite/accept', {
        method: 'POST',
        body: JSON.stringify({ token: inviteToken, password })
      });
      url.searchParams.delete('invite');
      window.history.replaceState({}, '', url.toString());
      form.reset();
      form.classList.add('hidden');
      loginForm.classList.remove('hidden');
      bootstrapForm.classList.add('hidden');
      showToast('Password saved. You can sign in now.');
    } catch (error) {
      showToast(error.message, true);
    }
  };
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
  if (previous === 'repAccountsView') {
    setView('repAccountsView', document.getElementById('repAccountsTitle')?.textContent || 'Rep Accounts', false);
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

document.addEventListener('keydown', async (event) => {
  if (event.key !== 'Escape') return;
  const overlay = document.querySelector('.action-modal-overlay');
  if (overlay) {
    overlay.click();
    return;
  }
  const activeView = VIEW_IDS.find((id) => !document.getElementById(id)?.classList.contains('hidden'));
  if (activeView === 'companyDetailView' && state.companyEditMode) {
    state.companyEditMode = false;
    renderCompanyDetail();
    return;
  }
  if (activeView === 'contactDetailView' && state.contactEditMode && state.currentContactId) {
    state.contactEditMode = false;
    await openContactDetail(state.currentContactId);
    return;
  }
  if (!els.backBtn.classList.contains('hidden')) {
    els.backBtn.onclick();
  }
});

document.getElementById('companySearch').oninput = (event) => {
  state.companyFilter = event.target.value;
  renderCompanies();
};

function toggleCreateCompany(show) {
  document.getElementById('createCompanyForm').classList.toggle('hidden', !show);
}

document.getElementById('showCreateCompanyBtn').onclick = () => toggleCreateCompany(true);
document.getElementById('quickAddCompanyBtn').onclick = () => toggleCreateCompany(true);
document.getElementById('cancelCreateCompanyBtn').onclick = () => toggleCreateCompany(false);

document.getElementById('createCompanyForm').onsubmit = async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    const country = String(fd.get('country') || 'US').toUpperCase();
    const mainPhoneError = validatePhoneByCountry(fd.get('mainPhone'), country, 'Main phone');
    if (mainPhoneError) throw new Error(mainPhoneError);
    await api('/api/companies', {
      method: 'POST',
      body: JSON.stringify({
        name: fd.get('name'),
        mainPhone: fd.get('mainPhone'),
        address: fd.get('address'),
        city: fd.get('city'),
        state: String(fd.get('state') || '').toUpperCase(),
        country,
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

try {
  const cached = localStorage.getItem(THEME_STORAGE_KEY);
  if (cached) {
    applyTheme(JSON.parse(cached), false);
  }
} catch {
}
initInviteSetupForm();
loadSession();
