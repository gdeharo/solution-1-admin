const state = {
  token: localStorage.getItem('crm_token') || null,
  user: null,
  companies: [],
  reps: [],
  currentCompany: null,
  companyContacts: [],
  companyInteractions: [],
  companyRowsTotal: 0,
  companyPage: 1,
  companyPageSize: 25,
  companySortBy: 'name',
  companySortDir: 'asc',
  companyDue14Only: false,
  companyPendingOnly: false,
  repAssignments: [],
  repTerritories: [],
  segments: [],
  customerTypes: [],
  segmentValues: [],
  typeValues: [],
  interactionTypeValues: [],
  theme: null,
  companySettings: { companyName: 'Company CRM', defaultCcEmail: '', featureNotificationEmail: '' },
  companyFilter: '',
  history: [],
  companyEditMode: false,
  contactEditMode: false,
  companySectionState: {},
  adminOpenSection: '',
  currentContactId: null,
  showInactiveUsers: false,
  repSearch: '',
  repFilterSegment: '',
  repFilterType: '',
  territoryRepSearch: '',
  selectedTerritoryRepId: 0,
  auditDays: 14,
  auditLimit: 50,
  weeklyReport: null,
  feedbackShowResolved: false,
  feedbackDate: '',
  feedbackUserId: ''
};

const API_BASE = window.CRM_API_BASE || '';
const THEME_STORAGE_KEY = 'crm_theme_v1';

const VIEW_IDS = [
  'authView',
  'companyListView',
  'weeklyReportView',
  'feedbackView',
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
  headerLogo: document.getElementById('headerLogo'),
  backBtn: document.getElementById('backBtn'),
  weeklyReportBtn: document.getElementById('weeklyReportBtn'),
  manageRepsBtn: document.getElementById('manageRepsBtn'),
  feedbackBtn: document.getElementById('feedbackBtn'),
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
const US_ZIP3_RANGES_BY_STATE = {
  AL: [['350', '369']],
  AK: [['995', '999']],
  AZ: [['850', '865']],
  AR: [['716', '729'], ['755', '755']],
  CA: [['900', '966']],
  CO: [['800', '816']],
  CT: [['060', '069']],
  DC: [['200', '205']],
  DE: [['197', '199']],
  FL: [['320', '349']],
  GA: [['300', '319'], ['398', '399']],
  HI: [['967', '968']],
  IA: [['500', '528']],
  ID: [['832', '838']],
  IL: [['600', '629']],
  IN: [['460', '479']],
  KS: [['660', '679']],
  KY: [['400', '427']],
  LA: [['700', '714']],
  MA: [['010', '027'], ['055', '055']],
  MD: [['206', '219']],
  ME: [['039', '049']],
  MI: [['480', '499']],
  MN: [['550', '567']],
  MO: [['630', '658']],
  MS: [['386', '397']],
  MT: [['590', '599']],
  NC: [['269', '289']],
  ND: [['580', '588']],
  NE: [['680', '693']],
  NH: [['030', '039']],
  NJ: [['070', '089']],
  NM: [['870', '884']],
  NV: [['889', '898']],
  NY: [['005', '005'], ['063', '063'], ['090', '149']],
  OH: [['430', '459']],
  OK: [['730', '749']],
  OR: [['970', '979']],
  PA: [['150', '196']],
  RI: [['028', '029']],
  SC: [['290', '299']],
  SD: [['570', '577']],
  TN: [['370', '385']],
  TX: [['750', '799'], ['885', '885']],
  UT: [['840', '847']],
  VA: [['201', '201'], ['220', '246']],
  VT: [['050', '059']],
  WA: [['980', '994']],
  WI: [['530', '549']],
  WV: [['247', '268']],
  WY: [['820', '831']]
};
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

function parseCompanySearchFilters(rawInput) {
  let rest = String(rawInput || '');
  const out = { q: '', state: '', city: '', rep: '' };
  const extract = (key) => {
    const re = new RegExp(`(?:^|\\s)${key}:(\"[^\"]+\"|[^\\s]+)`, 'ig');
    let match;
    while ((match = re.exec(rest))) {
      const token = String(match[1] || '').trim();
      if (!token) continue;
      const value = token.startsWith('"') && token.endsWith('"') ? token.slice(1, -1).trim() : token;
      if (!value) continue;
      out[key] = value;
      rest = `${rest.slice(0, match.index)} ${rest.slice(re.lastIndex)}`;
      re.lastIndex = 0;
    }
  };
  extract('state');
  extract('city');
  extract('rep');
  out.q = rest.replace(/\s+/g, ' ').trim();
  return out;
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
  const typeRaw = String(item.territory_type || '').trim();
  const type = ['state', 'city_state', 'zip_prefix', 'zip_exact'].includes(typeRaw) ? typeRaw : 'state';
  const rawZip = String(item.zip_prefix || item.zip_exact || '').trim();
  const zipDigits = rawZip.replace(/\D/g, '');
  const zipScope = zipDigits ? zipDigits : '-';
  const scope = type === 'city_state'
    ? `${item.city || ''}, ${item.state || ''}`.replace(/^,\s*/, '').trim()
    : type === 'state'
      ? (item.state || '')
      : zipScope;
  const core = `${type}${item.is_exclusion ? ' (exclude)' : ''}: ${scope || '-'}`;
  const filters = `${item.segment || 'All Segments'} / ${item.customer_type || 'All Types'}`;
  return `${core} | ${filters}`;
}

function territoryRuleHtml(item, includeClass = true) {
  const text = territoryRuleText(item);
  const className = includeClass && item.is_exclusion ? 'territory-snippet territory-exclude' : 'territory-snippet';
  return `<span class="${className}">${escapeHtml(text)}</span>`;
}

function toPositiveInt(value) {
  const n = Number.parseInt(String(value ?? '').trim(), 10);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

function shortDetails(valueJson) {
  if (!valueJson) return '';
  try {
    const parsed = typeof valueJson === 'string' ? JSON.parse(valueJson) : valueJson;
    const text = JSON.stringify(parsed);
    return text.length > 180 ? `${text.slice(0, 177)}...` : text;
  } catch {
    const raw = String(valueJson);
    return raw.length > 180 ? `${raw.slice(0, 177)}...` : raw;
  }
}

function companyHasMissingAddress(company) {
  return ['address', 'city', 'state', 'zip'].some((key) => !String(company?.[key] || '').trim());
}

function toLocalDateTimeInputValue(value = new Date()) {
  const date = value instanceof Date ? value : new Date(value);
  const pad = (num) => String(num).padStart(2, '0');
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function isImageAttachment(file) {
  return String(file?.mime_type || '').toLowerCase().startsWith('image/') || String(file?.file_name || '').startsWith('interaction-photo-');
}

function renderPhotoGridHtml(photos, canEdit = false) {
  const visiblePhotos = photos.slice(0, 4);
  const extraCount = Math.max(0, photos.length - 4);
  const cells = visiblePhotos.map((photo, index) => {
    const fileUrl = `${API_BASE}/api/files/${encodeURIComponent(photo.file_key)}?token=${encodeURIComponent(state.token || '')}`;
    const extraBadge = index === 3 && extraCount > 0 ? `<span class="photo-grid-count">+${extraCount}</span>` : '';
    return `<a class="photo-grid-item" href="${fileUrl}" target="_blank" rel="noreferrer">
      <img src="${fileUrl}" alt="${escapeHtml(photo.file_name || 'Interaction photo')}" class="contact-photo" />
      ${extraBadge}
    </a>`;
  });
  if (canEdit && cells.length < 4) {
    cells.push(`<button type="button" class="photo-grid-item photo-grid-add" id="interactionPhotoAddBtn">+</button>`);
  }
  while (cells.length < 4) {
    cells.push('<div class="photo-grid-item photo-grid-empty"></div>');
  }
  return `<div class="photo-grid">${cells.join('')}</div>`;
}

function normalizeZipForMatch(value) {
  return String(value || '').replace(/\D/g, '').trim();
}

function expandZipInputToken(rawToken) {
  const token = String(rawToken || '').trim();
  if (!token) return { tokens: [], invalid: false };
  const isExclusion = token.startsWith('-');
  const next = isExclusion ? token.slice(1).trim() : token;
  const rangeParts = next.split('..').map((part) => normalizeZipForMatch(part));
  if (rangeParts.length === 2) {
    const [start, end] = rangeParts;
    if (!start || !end || start.length !== end.length || (start.length !== 3 && start.length !== 5)) {
      return { tokens: [], invalid: true };
    }
    const startNum = Number.parseInt(start, 10);
    const endNum = Number.parseInt(end, 10);
    if (!Number.isFinite(startNum) || !Number.isFinite(endNum) || endNum < startNum || endNum - startNum > 500) {
      return { tokens: [], invalid: true };
    }
    return {
      tokens: Array.from({ length: endNum - startNum + 1 }, (_, index) => ({
        isExclusion,
        digits: String(startNum + index).padStart(start.length, '0'),
        raw: token
      })),
      invalid: false
    };
  }
  const digits = normalizeZipForMatch(next);
  if (!digits || (digits.length !== 3 && digits.length !== 5)) {
    return { tokens: [], invalid: true };
  }
  return {
    tokens: [{ isExclusion, digits, raw: token }],
    invalid: false
  };
}

function zipTokenToZip3Range(value) {
  const digits = normalizeZipForMatch(value);
  if (!digits) return null;
  if (digits.length === 5) {
    const zip3 = digits.slice(0, 3);
    return /^\d{3}$/.test(zip3) ? [zip3, zip3] : null;
  }
  if (digits.length === 3) {
    return /^\d{3}$/.test(digits) ? [digits, digits] : null;
  }
  return null;
}

function zipTokenMayOverlapState(value, stateCode) {
  const code = String(stateCode || '').trim().toUpperCase();
  const ranges = US_ZIP3_RANGES_BY_STATE[code];
  const zip3Range = zipTokenToZip3Range(value);
  if (!ranges || !zip3Range) return false;
  const [minZip3, maxZip3] = zip3Range;
  return ranges.some(([start, end]) => start <= maxZip3 && end >= minZip3);
}

function statesForZipToken(value) {
  if (!zipTokenToZip3Range(value)) return [];
  return US_STATES.filter((stateCode) => zipTokenMayOverlapState(value, stateCode));
}

function territoryRuleMatchesCompany(rule, company) {
  const companySegment = String(company.segment || '').trim();
  const companyType = String(company.customer_type || '').trim();
  if (rule.segment && rule.segment !== companySegment) return false;
  if (rule.customer_type && rule.customer_type !== companyType) return false;

  const ruleType = String(rule.territory_type || '');
  const companyState = String(company.state || '').trim().toUpperCase();
  const companyCity = String(company.city || '').trim().toUpperCase();
  const companyZip = normalizeZipForMatch(company.zip);
  if (ruleType === 'state') {
    return String(rule.state || '').trim().toUpperCase() === companyState;
  }
  if (ruleType === 'city_state') {
    return (
      String(rule.state || '').trim().toUpperCase() === companyState &&
      String(rule.city || '').trim().toUpperCase() === companyCity
    );
  }
  if (ruleType === 'zip_exact') {
    const zip = normalizeZipForMatch(rule.zip_exact);
    return !!zip && zip === companyZip;
  }
  if (ruleType === 'zip_prefix') {
    const prefix = normalizeZipForMatch(rule.zip_prefix);
    return !!prefix && companyZip.startsWith(prefix);
  }
  return false;
}

function companyIsInTerritory(company, territories) {
  const includes = territories.filter((t) => !t.is_exclusion);
  const excludes = territories.filter((t) => !!t.is_exclusion);
  const matchedInclude = includes.some((rule) => territoryRuleMatchesCompany(rule, company));
  if (!matchedInclude) return false;
  const matchedExclude = excludes.some((rule) => territoryRuleMatchesCompany(rule, company));
  return !matchedExclude;
}

function geographyOnlyMatch(rule, company) {
  const ruleType = String(rule.territory_type || '');
  const companyState = String(company.state || '').trim().toUpperCase();
  const companyCity = String(company.city || '').trim().toUpperCase();
  const companyZip = normalizeZipForMatch(company.zip);
  if (ruleType === 'state') return String(rule.state || '').trim().toUpperCase() === companyState;
  if (ruleType === 'city_state') {
    return (
      String(rule.state || '').trim().toUpperCase() === companyState &&
      String(rule.city || '').trim().toUpperCase() === companyCity
    );
  }
  if (ruleType === 'zip_exact') {
    const zip = normalizeZipForMatch(rule.zip_exact);
    return !!zip && zip === companyZip;
  }
  if (ruleType === 'zip_prefix') {
    const prefix = normalizeZipForMatch(rule.zip_prefix);
    return !!prefix && companyZip.startsWith(prefix);
  }
  return false;
}

function stateCheckboxGridHtml(fieldName, states) {
  return `<div class="state-grid">${states
    .map(
      (code) => `<label class="state-chip">
      <input type="checkbox" name="${fieldName}" value="${code}" />
      <span>${code}</span>
    </label>`
    )
    .join('')}</div>`;
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
  const req = scope === 'create' ? 'required' : '';
  const value = escapeHtml(currentState || '');
  let inner = '';
  if (country === 'US' || country === 'CA') {
    const options = (country === 'US' ? US_STATES : CA_PROVINCES)
      .map((code) => `<option value="${code}" ${code === currentState ? 'selected' : ''}>${code}</option>`)
      .join('');
    inner = `<span class="sr-only">State/Province</span><select name="state" aria-label="State/Province" ${dis} ${req}><option value="">State/Province</option>${options}</select>`;
  } else {
    inner = `<span class="sr-only">State/Province</span><input name="state" value="${value}" ${dis} ${req} placeholder="State/Province" aria-label="State/Province" />`;
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

  applyHeaderBranding();
  els.pageHint.textContent = hint;
  els.backBtn.classList.toggle('hidden', viewId === 'companyListView' || viewId === 'authView');
}

function companyLogoUrl() {
  if (!state.companySettings?.logoKey || !state.token) return '';
  return `${API_BASE}/api/settings/company/logo?token=${encodeURIComponent(state.token)}`;
}

function applyHeaderBranding() {
  els.pageTitle.textContent = state.companySettings?.companyName || 'Company CRM';
  if (els.headerLogo) {
    const logoUrl = companyLogoUrl();
    if (logoUrl) {
      els.headerLogo.src = logoUrl;
      els.headerLogo.classList.remove('hidden');
    } else {
      els.headerLogo.removeAttribute('src');
      els.headerLogo.classList.add('hidden');
    }
  }
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

  if (!response.ok) {
    const error = new Error(data?.error || `Request failed (${response.status})`);
    error.status = response.status;
    error.data = data;
    throw error;
  }
  return data;
}

async function loadCompanies() {
  const parsed = parseCompanySearchFilters(state.companyFilter);
  const params = new URLSearchParams();
  params.set('page', String(state.companyPage));
  params.set('pageSize', String(state.companyPageSize));
  params.set('sortBy', state.companySortBy || 'name');
  params.set('sortDir', state.companySortDir || 'asc');
  if (parsed.q) params.set('q', parsed.q);
  if (parsed.state) params.set('state', parsed.state);
  if (parsed.city) params.set('city', parsed.city);
  if (parsed.rep) params.set('rep', parsed.rep);
  if (state.companyDue14Only) params.set('dueDays', '14');
  if (state.companyPendingOnly) params.set('pendingOnly', '1');
  const result = await api(`/api/companies?${params.toString()}`);
  state.companies = result.companies || [];
  state.companyRowsTotal = Number(result.total || 0);
  state.companyPage = Number(result.page || state.companyPage);
  state.companyPageSize = Number(result.pageSize || state.companyPageSize);
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

function renderCompanies() {
  const rows = state.companies;
  const body = document.getElementById('companiesBody');
  body.innerHTML = rows
    .map(
      (c) => `<tr class="clickable" data-company-id="${c.id}">
      <td>${(Number(c.has_incomplete_address) || companyHasMissingAddress(c)) ? '<span class="warning-badge" title="Missing address information">!</span>' : ''}${escapeHtml(c.name)}</td>
      <td>${escapeHtml(c.city || '')}</td>
      <td>${escapeHtml(c.state || '')}</td>
      <td>${c.last_interaction_at ? escapeHtml(new Date(c.last_interaction_at).toLocaleDateString()) : '-'}</td>
      <td>${c.next_action_at ? escapeHtml(new Date(c.next_action_at).toLocaleDateString()) : '-'}</td>
      <td>${escapeHtml(c.rep_names || '-')}</td>
    </tr>`
    )
    .join('');

  document.getElementById('noCompanyMatch').classList.toggle('hidden', rows.length > 0 || state.companyRowsTotal > 0);
  document.getElementById('quickAddCompanyBtn').classList.toggle('hidden', !canWrite());
  const dueBtn = document.getElementById('due14FilterBtn');
  const pendingBtn = document.getElementById('pendingInteractionFilterBtn');
  const sortSelect = document.getElementById('companySortSelect');
  const sortDirSelect = document.getElementById('companySortDirSelect');
  if (dueBtn) dueBtn.classList.toggle('ghost', !state.companyDue14Only);
  if (pendingBtn) pendingBtn.classList.toggle('ghost', !state.companyPendingOnly);
  if (sortSelect) sortSelect.value = state.companySortBy || 'name';
  if (sortDirSelect) sortDirSelect.value = state.companySortDir || 'asc';

  const pageInfo = document.getElementById('companyPageInfo');
  const totalPages = Math.max(1, Math.ceil((state.companyRowsTotal || 0) / state.companyPageSize));
  if (pageInfo) pageInfo.textContent = `Page ${state.companyPage} of ${totalPages} (${state.companyRowsTotal} total)`;
  const prevBtn = document.getElementById('companyPrevPageBtn');
  const nextBtn = document.getElementById('companyNextPageBtn');
  if (prevBtn) prevBtn.disabled = state.companyPage <= 1;
  if (nextBtn) nextBtn.disabled = state.companyPage >= totalPages;

  body.querySelectorAll('tr[data-company-id]').forEach((row) => {
    row.onclick = () => openCompany(Number(row.dataset.companyId));
  });
}

async function openFeedbackView() {
  const createForm = document.getElementById('feedbackCreateForm');
  const filterForm = document.getElementById('feedbackFilterForm');
  const body = document.getElementById('feedbackBody');
  if (!createForm || !filterForm || !body) return;

  createForm.innerHTML = `
    <label><span class="field-caption">Date/Time</span><input name="feedbackAt" type="datetime-local" value="${toLocalDateTimeInputValue()}" required /></label>
    <label><span class="field-caption">User</span><input value="${escapeHtml(state.user?.fullName || '')}" disabled /></label>
    <label class="full"><span class="field-caption">Feedback</span><textarea name="message" rows="5" placeholder="Describe the issue, request, or observation" required></textarea></label>
    <label class="row wrap"><input name="isResolved" type="checkbox" /> Resolved</label>
    <div class="row wrap full">
      <button type="submit">Save Feedback</button>
    </div>
  `;

  const loadFeedback = async () => {
    const params = new URLSearchParams();
    if (state.feedbackShowResolved) params.set('includeResolved', '1');
    if (state.feedbackDate) params.set('date', state.feedbackDate);
    if (state.feedbackUserId) params.set('userId', state.feedbackUserId);
    const data = await api(`/api/feedback?${params.toString()}`);
    const entries = Array.isArray(data.entries) ? data.entries : [];
    const users = Array.isArray(data.users) ? data.users : [];
    filterForm.innerHTML = `
      <label><span class="field-caption">Date</span><input name="date" type="date" value="${escapeHtml(state.feedbackDate || '')}" /></label>
      <label><span class="field-caption">User</span><select name="userId"><option value="">All users</option>${users
        .map((user) => `<option value="${toPositiveInt(user.id)}" ${String(state.feedbackUserId) === String(user.id) ? 'selected' : ''}>${escapeHtml(user.full_name || '')}</option>`)
        .join('')}</select></label>
      <button type="submit">Apply</button>
      <button type="button" id="feedbackToggleResolvedBtn" class="ghost">${state.feedbackShowResolved ? 'Hide Resolved' : 'Show All'}</button>
    `;
    body.innerHTML = entries.length
      ? entries
          .map(
            (entry) => `<tr>
        <td>${entry.feedback_at ? new Date(entry.feedback_at).toLocaleString() : '-'}</td>
        <td>${escapeHtml(entry.user_name || '')}</td>
        <td class="readonly-multiline">${escapeHtml(entry.message || '')}</td>
        <td><input type="checkbox" data-feedback-resolved="${entry.id}" ${entry.is_resolved ? 'checked' : ''} /></td>
      </tr>`
          )
          .join('')
      : '<tr><td colspan="4" class="tiny">No feedback found.</td></tr>';

    document.querySelectorAll('[data-feedback-resolved]').forEach((el) => {
      el.onchange = async () => {
        try {
          await api(`/api/feedback/${toPositiveInt(el.dataset.feedbackResolved)}`, {
            method: 'PATCH',
            body: JSON.stringify({ isResolved: !!el.checked })
          });
          await loadFeedback();
        } catch (error) {
          showToast(error.message, true);
        }
      };
    });

    filterForm.onsubmit = async (event) => {
      event.preventDefault();
      const fd = new FormData(filterForm);
      state.feedbackDate = String(fd.get('date') || '');
      state.feedbackUserId = String(fd.get('userId') || '');
      await loadFeedback();
    };
    const toggleBtn = document.getElementById('feedbackToggleResolvedBtn');
    if (toggleBtn) {
      toggleBtn.onclick = async () => {
        state.feedbackShowResolved = !state.feedbackShowResolved;
        await loadFeedback();
      };
    }
  };

  createForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(createForm);
    try {
      await api('/api/feedback', {
        method: 'POST',
        body: JSON.stringify({
          feedbackAt: String(fd.get('feedbackAt') || ''),
          message: String(fd.get('message') || ''),
          isResolved: !!fd.get('isResolved')
        })
      });
      createForm.reset();
      await loadFeedback();
      showToast('Feedback saved');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  await loadFeedback();
  setView('feedbackView', 'Feedback');
}

function repOptions(selectedIds = []) {
  return state.reps
    .map((rep) => `<option value="${rep.id}" ${selectedIds.includes(rep.id) ? 'selected' : ''}>${escapeHtml(rep.full_name)}</option>`)
    .join('');
}

function toProperCaseDisplay(value) {
  return String(value || '')
    .toLowerCase()
    .replace(/\b([a-z])/g, (match) => match.toUpperCase());
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
  const displayName = c.name ? toProperCaseDisplay(c.name) : '-';
  const displayAddress = c.address ? toProperCaseDisplay(c.address) : '-';
  const displayCity = c.city ? toProperCaseDisplay(c.city) : '-';
  const displaySegment = c.segment ? toProperCaseDisplay(c.segment) : '-';
  const displayCustomerType = c.customer_type ? toProperCaseDisplay(c.customer_type) : '-';
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
          : `<div class="readonly-value">${escapeHtml(displayName)}</div>`
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
              : `<div class="readonly-value">${escapeHtml(displayAddress)}</div>`
          }</label>
          <label><span class="sr-only">City</span>${
            isEditing
              ? `<input name="city" value="${escapeHtml(c.city || '')}" placeholder="City" aria-label="City" ${readOnly} />`
              : `<div class="readonly-value">${escapeHtml(displayCity)}</div>`
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
              : `<div class="readonly-value">${escapeHtml(displaySegment)}</div>`
          }</label>
          <label><span class="sr-only">Type</span>${
            isEditing
              ? `<select name="customerType" aria-label="Type" ${readOnly}>${typeOptions}</select>`
              : `<div class="readonly-value">${escapeHtml(displayCustomerType)}</div>`
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
               ${canManageReps() ? `<button type="button" id="deleteCompanyBtn" class="danger">Delete Company</button>` : ''}`
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
        <td>${new Date(i.interaction_at || i.created_at).toLocaleDateString()}</td>
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
      const companyName = state.currentCompany?.name || 'this company';
      if (!confirm(`Delete "${companyName}"?\n\nThis hides the company and related records from normal views.`)) return;
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
    interactionAt: draft?.interactionAt || new Date().toISOString().slice(0, 10),
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
            <label><span class="field-caption">Visit date</span><input name="interactionAt" type="date" aria-label="Visit date" value="${escapeHtml(
              initial.interactionAt
            )}" /></label>
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
          <input id="interactionCreatePhotoInput" name="photo" type="file" accept="image/*" multiple class="hidden" />
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
      const files = Array.from(createPhotoInput.files || []).filter((file) => file.size > 0).slice(0, 4);
      if (!files.length) return;
      createPhotoPreview.innerHTML = renderPhotoGridHtml(
        files.map((file, index) => ({
          file_key: URL.createObjectURL(file),
          file_name: file.name || `Photo ${index + 1}`,
          mime_type: file.type || 'image/jpeg'
        })),
        true
      );
      const addBtn = document.getElementById('interactionPhotoAddBtn');
      if (addBtn) addBtn.onclick = () => createPhotoInput.click();
    };
  }

  form.querySelector('[name="customerId"]').onchange = async (event) => {
    if (event.target.value !== '__new_contact__') return;
    const fd = new FormData(form);
      const interactionDraft = {
        customerId: '',
        interactionType: fd.get('interactionType') || '',
        interactionAt: fd.get('interactionAt') || '',
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
          interactionAt: fd.get('interactionAt') ? toIsoDateStart(String(fd.get('interactionAt'))) : null,
          meetingNotes: fd.get('meetingNotes'),
          nextAction: fd.get('nextAction'),
          nextActionAt: fd.get('nextActionAt') ? toIsoDateStart(String(fd.get('nextActionAt'))) : null
        })
      });
      const photos = Array.from(createPhotoInput?.files || []).filter((file) => file.size > 0);
      for (let index = 0; index < photos.length; index += 1) {
        const processedPhoto = await toSquareImageFile(photos[index]);
        const formData = new FormData();
        formData.set('entityType', 'interaction');
        formData.set('entityId', String(created.id));
        formData.set(
          'file',
          new File([processedPhoto], `interaction-photo-${Date.now()}-${index + 1}.jpg`, {
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
            <label><span class="field-caption">Visit date</span><input name="interactionAt" type="date" aria-label="Visit date" value="${
              (interaction.interaction_at || interaction.created_at) ? new Date(interaction.interaction_at || interaction.created_at).toISOString().slice(0, 10) : ''
            }" ${readOnly} /></label>
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
          <input id="interactionPhotoInput" type="file" accept="image/*" multiple class="hidden" />
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
          interactionAt: fd.get('interactionAt') ? toIsoDateStart(String(fd.get('interactionAt'))) : null,
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
      const photos = attachments.filter((a) => isImageAttachment(a));

      const photoContainer = document.getElementById('interactionPhotoPreview');
      if (photos.length) {
        photoContainer.innerHTML = renderPhotoGridHtml(photos, canWrite());
      } else {
        photoContainer.innerHTML = canWrite()
          ? renderPhotoGridHtml([], true)
          : '<span class="muted">No photos</span>';
      }
      const addBtn = document.getElementById('interactionPhotoAddBtn');
      if (addBtn && canWrite()) addBtn.onclick = () => document.getElementById('interactionPhotoInput')?.click();

      const docs = attachments.filter((a) => !isImageAttachment(a));
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
    interactionPhotoTile.onclick = (event) => {
      if (event.target.closest('a')) return;
      if (event.target.id === 'interactionPhotoAddBtn') return;
      interactionPhotoInput.click();
    };
    interactionPhotoInput.onchange = async () => {
      const rawFiles = Array.from(interactionPhotoInput.files || []).filter((file) => file.size > 0);
      if (!rawFiles.length) return;
      try {
        for (let index = 0; index < rawFiles.length; index += 1) {
          const processedFile = await toSquareImageFile(rawFiles[index]);
          const formData = new FormData();
          formData.set('entityType', 'interaction');
          formData.set('entityId', String(interactionId));
          formData.set(
            'file',
            new File([processedFile], `interaction-photo-${Date.now()}-${index + 1}.jpg`, { type: processedFile.type || 'image/jpeg' })
          );
          await api('/api/files/upload', { method: 'POST', body: formData, headers: {} });
        }
        await renderInteractionAssets();
        showToast(rawFiles.length > 1 ? 'Photos uploaded' : 'Photo uploaded');
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
  state.reps = Array.isArray(data.reps) ? data.reps : [];
  state.repAssignments = Array.isArray(data.assignments) ? data.assignments : [];
  state.repTerritories = Array.isArray(data.territories) ? data.territories : [];
  const isAdmin = state.user?.role === 'admin';
  let users = [];
  try {
    const companySettingsData = await api('/api/settings/company');
    state.companySettings = companySettingsData.settings || state.companySettings;
    applyHeaderBranding();
  } catch {
  }
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
        <button type="button" class="danger small-btn" title="Delete" aria-label="Delete" data-delete-interaction-type="${item.id}">⌦</button>
      </li>`
    )
    .join('');

  const repSearchEl = document.getElementById('repSearch');
  const repFilterSegmentEl = document.getElementById('repFilterSegment');
  const repFilterTypeEl = document.getElementById('repFilterType');
  if (repFilterSegmentEl) {
    repFilterSegmentEl.innerHTML = `<option value="">All segments</option>${state.segments
      .map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`)
      .join('')}`;
    repFilterSegmentEl.value = state.repFilterSegment || '';
  }
  if (repFilterTypeEl) {
    repFilterTypeEl.innerHTML = `<option value="">All types</option>${state.customerTypes
      .map((name) => `<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`)
      .join('')}`;
    repFilterTypeEl.value = state.repFilterType || '';
  }
  if (repSearchEl) repSearchEl.value = state.repSearch || '';

  const renderRepsTable = () => {
    const filteredReps = state.reps.filter((rep) => {
      const bySearch = !state.repSearch || String(rep.full_name || '').toLowerCase().includes(state.repSearch.toLowerCase());
      if (!bySearch) return false;
      if (state.repFilterSegment && rep.segment !== state.repFilterSegment) return false;
      if (state.repFilterType && rep.customer_type !== state.repFilterType) return false;
      return true;
    });
    document.getElementById('repsBody').innerHTML = filteredReps
      .map((rep) => {
      const repId = toPositiveInt(rep.id);
      if (!repId) return '';
      const companies = state.repAssignments.filter((a) => toPositiveInt(a.rep_id) === repId).map((a) => a.company_name);
      const territories = state.repTerritories.filter((t) => toPositiveInt(t.rep_id) === repId);
      const territoryCount = Number.isFinite(territories.length) ? territories.length : 0;
      const territoryPreview = territories.slice(0, 2).map((item) => territoryRuleHtml(item)).join('');
      const territoryMore = territoryCount > 2 ? `<div class="tiny">+${territoryCount - 2} more</div>` : '';
      const linkedUserId = toPositiveInt(rep.user_id);
      return `<tr class="clickable" data-open-rep-detail="${repId}">
        <td>${escapeHtml(rep.full_name)}</td>
        <td>${escapeHtml(rep.email || '')}</td>
        <td>${escapeHtml(rep.phone || '')}</td>
        <td>${rep.last_entry_at ? new Date(rep.last_entry_at).toLocaleDateString() : '-'}</td>
        <td>${escapeHtml(companies.join(', ') || '-')}</td>
        <td class="territory-cell">
          ${territoryCount ? `${territoryPreview}${territoryMore}` : '<span class="tiny">No territories assigned</span>'}
        </td>
        <td>${!linkedUserId ? `<button type="button" class="danger small-btn" data-delete-rep="${repId}" onclick="event.stopPropagation();">⌦</button>` : ''}</td>
      </tr>`;
      })
      .join('');
  };
  renderRepsTable();

  document.getElementById('territoryForm').innerHTML = `
    <div class="full territory-editor">
      <div class="rep-picker">
        <input id="territoryRepSearch" placeholder="Find rep" />
        <input type="hidden" name="repId" />
        <div id="territoryRepList" class="rep-picker-list" aria-label="Territory rep list"></div>
      </div>
      <div class="field-group">
        <strong>Type</strong>
        <div class="row wrap">
          ${state.customerTypes
            .map(
              (name) => `<label class="state-chip">
            <input type="checkbox" name="customerTypes" value="${escapeHtml(name)}" />
            <span>${escapeHtml(name)}</span>
          </label>`
            )
            .join('')}
        </div>
      </div>
      <div class="field-group">
        <strong>Segment</strong>
        <div class="row wrap">
          ${state.segments
            .map(
              (name) => `<label class="state-chip">
            <input type="checkbox" name="segments" value="${escapeHtml(name)}" />
            <span>${escapeHtml(name)}</span>
          </label>`
            )
            .join('')}
        </div>
      </div>
      <div class="field-group">
        <strong>USA States</strong>
        <p class="tiny">Green selected, red conflict with another rep in same segment/type.</p>
        ${stateCheckboxGridHtml('states', US_STATES)}
      </div>
      <div class="field-group">
        <strong>Canada Provinces</strong>
        ${stateCheckboxGridHtml('states', CA_PROVINCES)}
      </div>
      <div class="field-group">
        <strong>Zip Rules</strong>
        <textarea name="zipCodes" rows="2" placeholder="901, 90210, 900..930, -905, -910..915"></textarea>
        <p class="tiny">Use commas/new lines. Prefix with '-' to exclude. Allowed: 3-digit ZIP3 or 5-digit ZIP.</p>
        <div id="territoryZipPreview" class="tiny"></div>
        <div id="territoryConflictPreview" class="tiny"></div>
      </div>
      <div id="territoryDraftSummary" class="tiny"></div>
      <div class="row wrap">
        <button type="submit">Save Territory Scope</button>
      </div>
    </div>
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

  document.getElementById('auditFilterForm').innerHTML = `
    <select name="days" aria-label="Days">
      <option value="7" ${String(state.auditDays) === '7' ? 'selected' : ''}>Last 7 days</option>
      <option value="14" ${String(state.auditDays) === '14' ? 'selected' : ''}>Last 14 days</option>
      <option value="30" ${String(state.auditDays) === '30' ? 'selected' : ''}>Last 30 days</option>
      <option value="90" ${String(state.auditDays) === '90' ? 'selected' : ''}>Last 90 days</option>
    </select>
    <select name="limit" aria-label="Rows">
      <option value="25" ${String(state.auditLimit) === '25' ? 'selected' : ''}>25 rows</option>
      <option value="50" ${String(state.auditLimit) === '50' ? 'selected' : ''}>50 rows</option>
      <option value="100" ${String(state.auditLimit) === '100' ? 'selected' : ''}>100 rows</option>
    </select>
    <button type="submit">Refresh</button>
  `;
  document.getElementById('auditBody').innerHTML = '<tr><td colspan="5" class="tiny">Loading...</td></tr>';

  const userCard = document.getElementById('userAdminCard');
  userCard.classList.toggle('hidden', !isAdmin);
  const companySettingsCard = document.getElementById('companySettingsCard');
  companySettingsCard.classList.toggle('hidden', !isAdmin);
  if (isAdmin) {
    document.getElementById('userCreateForm').innerHTML = `
      <input name="fullName" placeholder="Full name" required />
      <input name="email" placeholder="Email" type="email" required />
      <input name="phone" placeholder="Phone (optional)" />
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
    document.getElementById('companySettingsForm').innerHTML = `
      <input name="companyName" placeholder="Company Name" value="${escapeHtml(state.companySettings?.companyName || '')}" required />
      <input name="defaultCcEmail" placeholder="Default CC Email" type="email" value="${escapeHtml(state.companySettings?.defaultCcEmail || '')}" />
      <input name="featureNotificationEmail" placeholder="Feature Notification Email" type="email" value="${escapeHtml(state.companySettings?.featureNotificationEmail || '')}" />
      <input name="logoFile" type="file" accept="image/*" />
      ${state.companySettings?.logoKey ? `<button type="button" class="ghost" id="deleteCompanyLogoBtn">Delete Logo</button>` : ''}
      <button type="button" class="ghost" id="normalizeCompanyCaseBtn">Normalize Existing Companies</button>
      <button type="submit">Save Company Settings</button>
    `;
  } else {
    document.getElementById('userCreateForm').innerHTML = '';
    document.getElementById('usersBody').innerHTML = '';
    document.getElementById('companySettingsForm').innerHTML = '';
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

  const companySettingsForm = document.getElementById('companySettingsForm');
  if (companySettingsForm && state.user?.role === 'admin') {
    companySettingsForm.onsubmit = async (event) => {
      event.preventDefault();
      const fd = new FormData(companySettingsForm);
      try {
        const logoFile = fd.get('logoFile');
        let logoKey = state.companySettings?.logoKey || '';
        if (logoFile instanceof File && logoFile.size > 0) {
          const uploadForm = new FormData();
          uploadForm.set('file', logoFile);
          const upload = await api('/api/settings/company/logo', {
            method: 'POST',
            body: uploadForm,
            headers: {}
          });
          logoKey = upload.logoKey || logoKey;
        }
        const result = await api('/api/settings/company', {
          method: 'PUT',
          body: JSON.stringify({
            companyName: String(fd.get('companyName') || ''),
            defaultCcEmail: String(fd.get('defaultCcEmail') || ''),
            featureNotificationEmail: String(fd.get('featureNotificationEmail') || ''),
            logoKey
          })
        });
        state.companySettings = result.settings || state.companySettings;
        applyHeaderBranding();
        await renderRepsView();
        showToast('Company settings updated');
      } catch (error) {
        showToast(error.message, true);
      }
    };
    const deleteCompanyLogoBtn = document.getElementById('deleteCompanyLogoBtn');
    if (deleteCompanyLogoBtn) {
      deleteCompanyLogoBtn.onclick = async () => {
        try {
          await api('/api/settings/company/logo', { method: 'DELETE' });
          state.companySettings.logoKey = '';
          applyHeaderBranding();
          await renderRepsView();
          showToast('Logo removed');
        } catch (error) {
          showToast(error.message, true);
        }
      };
    }
    const normalizeCompanyCaseBtn = document.getElementById('normalizeCompanyCaseBtn');
    if (normalizeCompanyCaseBtn) {
      normalizeCompanyCaseBtn.onclick = async () => {
        if (!confirm('Normalize existing company name, address, and city values to proper case?')) return;
        try {
          const result = await api('/api/settings/company/normalize-company-case', { method: 'POST' });
          showToast(`Normalized ${Number(result.updated || 0)} companies`);
          if (state.currentCompany?.id) await openCompany(state.currentCompany.id, false);
          else await loadCompanies();
        } catch (error) {
          showToast(error.message, true);
        }
      };
    }
  }

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

  document.querySelectorAll('[data-delete-interaction-type]').forEach((btn) => {
    btn.onclick = async () => {
      const id = Number(btn.dataset.deleteInteractionType);
      const current = state.interactionTypeValues.find((x) => x.id === id);
      if (!id || !current) return;
      if (!confirm(`Delete meeting type "${current.name}"? Existing interactions using it will be cleared.`)) return;
      try {
        await api(`/api/interaction-types/${id}`, { method: 'DELETE' });
        await loadMetadata();
        await renderRepsView();
        showToast('Meeting type deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

  const repSearchEl = document.getElementById('repSearch');
  const repFilterSegmentEl = document.getElementById('repFilterSegment');
  const repFilterTypeEl = document.getElementById('repFilterType');
  if (repSearchEl) {
    repSearchEl.oninput = () => {
      state.repSearch = repSearchEl.value || '';
      renderRepsView();
    };
  }
  if (repFilterSegmentEl) {
    repFilterSegmentEl.onchange = () => {
      state.repFilterSegment = repFilterSegmentEl.value || '';
      renderRepsView();
    };
  }
  if (repFilterTypeEl) {
    repFilterTypeEl.onchange = () => {
      state.repFilterType = repFilterTypeEl.value || '';
      renderRepsView();
    };
  }

  const auditForm = document.getElementById('auditFilterForm');
  const loadAuditLog = async () => {
    const auditBody = document.getElementById('auditBody');
    if (!auditBody) return;
    try {
      const data = await api(`/api/audit-log?days=${encodeURIComponent(state.auditDays)}&limit=${encodeURIComponent(state.auditLimit)}`);
      const rows = Array.isArray(data?.entries) ? data.entries : [];
      auditBody.innerHTML = rows.length
        ? rows
            .map(
              (row) => `<tr>
          <td>${row.created_at ? new Date(row.created_at).toLocaleString() : '-'}</td>
          <td>${escapeHtml(row.actor_name || row.actor_email || 'System')}</td>
          <td>${escapeHtml(row.action || '')}</td>
          <td>${escapeHtml(`${row.entity_type || ''} #${row.entity_id || ''}`)}</td>
          <td class="tiny">${escapeHtml(shortDetails(row.details_json) || '-')}</td>
        </tr>`
            )
            .join('')
        : '<tr><td colspan="5" class="tiny">No changes in this period.</td></tr>';
    } catch (error) {
      auditBody.innerHTML = `<tr><td colspan="5" class="tiny">${escapeHtml(error.message || 'Could not load')}</td></tr>`;
    }
  };
  if (auditForm) {
    auditForm.onsubmit = async (event) => {
      event.preventDefault();
      const fd = new FormData(auditForm);
      state.auditDays = Number(fd.get('days')) || 14;
      state.auditLimit = Number(fd.get('limit')) || 50;
      await loadAuditLog();
    };
    loadAuditLog();
  }

  const territoryForm = document.getElementById('territoryForm');
  if (!territoryForm) return;
  const repSelectEl = territoryForm.querySelector('[name="repId"]');
  const zipCodesEl = territoryForm.querySelector('[name="zipCodes"]');
  const repSearchPickerEl = territoryForm.querySelector('#territoryRepSearch');
  const repPickerListEl = territoryForm.querySelector('#territoryRepList');
  if (!repSelectEl || !zipCodesEl || !repSearchPickerEl || !repPickerListEl) return;

  const getCheckedValues = (fieldName) =>
    Array.from(territoryForm.querySelectorAll(`input[name="${fieldName}"]:checked`)).map((el) => el.value);

  const clearTerritorySelections = () => {
    territoryForm.querySelectorAll('input[name="states"], input[name="segments"], input[name="customerTypes"]').forEach((el) => {
      el.checked = false;
    });
    zipCodesEl.value = '';
  };

  const parseDraftZipTokens = () => {
    const invalidTokens = [];
    const tokens = String(zipCodesEl.value || '')
      .split(/[\n,]/g)
      .map((part) => part.trim())
      .filter(Boolean)
      .flatMap((token) => {
        const expanded = expandZipInputToken(token);
        if (expanded.invalid) invalidTokens.push(token);
        return expanded.tokens;
      });
    return { tokens, invalidTokens };
  };

  const computeCurrentConflicts = () => {
    const repId = toPositiveInt(repSelectEl.value);
    const segments = getCheckedValues('segments');
    const customerTypes = getCheckedValues('customerTypes');
    const states = getCheckedValues('states').map((s) => String(s || '').toUpperCase());
    const { tokens: zipTokens } = parseDraftZipTokens();

    const conflictStateSet = new Set();
    const conflictEntries = [];
    const eligibleRules = state.repTerritories.filter((rule) => {
      if (toPositiveInt(rule.rep_id) === repId) return false;
      if (rule.is_exclusion) return false;
      if (segments.length > 0 && !segments.includes(rule.segment || '')) return false;
      if (customerTypes.length > 0 && !customerTypes.includes(rule.customer_type || '')) return false;
      return true;
    });
    const repNameById = new Map(state.reps.map((r) => [toPositiveInt(r.id), r.full_name || `Rep #${r.id}`]));

    for (const stateCode of states) {
      for (const rule of eligibleRules) {
        if (rule.territory_type === 'state' && String(rule.state || '').toUpperCase() === stateCode) {
          conflictStateSet.add(stateCode);
          const repName = repNameById.get(toPositiveInt(rule.rep_id)) || 'Rep';
          const typeName = String(rule.customer_type || 'All Types');
          const segmentName = String(rule.segment || 'All Segments');
          conflictEntries.push({
            repName,
            typeName,
            segmentName,
            territoryType: 'state',
            where: stateCode
          });
          continue;
        }
        if (rule.territory_type === 'zip_exact' || rule.territory_type === 'zip_prefix') {
          const zipToken = rule.territory_type === 'zip_exact' ? rule.zip_exact : rule.zip_prefix;
          if (!zipTokenMayOverlapState(zipToken, stateCode)) continue;
          conflictStateSet.add(stateCode);
          const repName = repNameById.get(toPositiveInt(rule.rep_id)) || 'Rep';
          const typeName = String(rule.customer_type || 'All Types');
          const segmentName = String(rule.segment || 'All Segments');
          conflictEntries.push({
            repName,
            typeName,
            segmentName,
            territoryType: rule.territory_type,
            where: normalizeZipForMatch(zipToken) || '-'
          });
        }
      }
    }

    const includeZips = zipTokens.filter((t) => !t.isExclusion);
    for (const token of includeZips) {
      const digits = token.digits;
      for (const rule of eligibleRules) {
        const ruleZipExact = String(rule.zip_exact || '').replace(/\D/g, '');
        const ruleZipPrefix = String(rule.zip_prefix || '').replace(/\D/g, '');
        let matches = false;
        if (digits.length === 5) {
          if (rule.territory_type === 'zip_exact' && ruleZipExact === digits) matches = true;
          if (rule.territory_type === 'zip_prefix' && ruleZipPrefix && digits.startsWith(ruleZipPrefix)) matches = true;
        } else {
          if (rule.territory_type === 'zip_exact' && ruleZipExact.startsWith(digits)) matches = true;
          if (rule.territory_type === 'zip_prefix' && ruleZipPrefix && (digits.startsWith(ruleZipPrefix) || ruleZipPrefix.startsWith(digits))) {
            matches = true;
          }
        }
        if (!matches) continue;
        const repName = repNameById.get(toPositiveInt(rule.rep_id)) || 'Rep';
        const where = rule.territory_type === 'zip_exact' ? ruleZipExact : ruleZipPrefix;
        const typeName = String(rule.customer_type || 'All Types');
        const segmentName = String(rule.segment || 'All Segments');
        conflictEntries.push({
          repName,
          typeName,
          segmentName,
          territoryType: rule.territory_type,
          where: where || '-'
        });
      }
      for (const rule of eligibleRules) {
        if (rule.territory_type !== 'state') continue;
        if (!zipTokenMayOverlapState(digits, rule.state)) continue;
        const repName = repNameById.get(toPositiveInt(rule.rep_id)) || 'Rep';
        const typeName = String(rule.customer_type || 'All Types');
        const segmentName = String(rule.segment || 'All Segments');
        conflictEntries.push({
          repName,
          typeName,
          segmentName,
          territoryType: 'state',
          where: String(rule.state || '').toUpperCase() || '-'
        });
      }
    }
    const grouped = new Map();
    for (const entry of conflictEntries) {
      const key = `${entry.repName}||${entry.typeName}||${entry.segmentName}||${entry.territoryType}`;
      if (!grouped.has(key)) {
        grouped.set(key, {
          repName: entry.repName,
          typeName: entry.typeName,
          segmentName: entry.segmentName,
          territoryType: entry.territoryType,
          locations: new Set()
        });
      }
      grouped.get(key).locations.add(entry.where);
    }
    const conflictDetails = Array.from(grouped.values()).map((group) => {
      const loc = Array.from(group.locations).join(', ');
      return `${group.repName} • ${group.typeName} • ${group.segmentName} • ${group.territoryType}:${loc}`;
    });
    return {
      conflictStateSet,
      conflictDetails
    };
  };

  const updateTerritoryConflictHighlights = () => {
    const conflictPreviewEl = document.getElementById('territoryConflictPreview');
    const zipPreviewEl = document.getElementById('territoryZipPreview');
    const draftSummaryEl = document.getElementById('territoryDraftSummary');
    if (!conflictPreviewEl || !zipPreviewEl || !draftSummaryEl) return;
    const { conflictStateSet, conflictDetails } = computeCurrentConflicts();
    const selectedStates = new Set(getCheckedValues('states').map((s) => String(s || '').toUpperCase()));
    const selectedSegments = getCheckedValues('segments');
    const selectedTypes = getCheckedValues('customerTypes');
    const { tokens: zipTokens, invalidTokens } = parseDraftZipTokens();
    const includeCount = zipTokens.filter((token) => !token.isExclusion).length;
    const excludeCount = zipTokens.filter((token) => token.isExclusion).length;
    const impliedStateSet = new Set();
    const tokenHints = [];
    for (const token of zipTokens) {
      const matchingStates = statesForZipToken(token.digits);
      const tokenLabel = `${token.isExclusion ? '-' : ''}${token.digits}`;
      if (matchingStates.length === 0) tokenHints.push(`${tokenLabel} -> ?`);
      else tokenHints.push(`${tokenLabel} -> ${matchingStates.join(', ')}`);
      for (const stateCode of matchingStates) impliedStateSet.add(stateCode);
    }
    const mismatchStates = new Set(
      selectedStates.size > 0 ? Array.from(impliedStateSet).filter((code) => !selectedStates.has(code)) : []
    );
    territoryForm.querySelectorAll('input[name="states"]').forEach((cb) => {
      const label = cb.closest('.state-chip');
      if (!label) return;
      const stateCode = String(cb.value || '').toUpperCase();
      const isImplied = impliedStateSet.has(stateCode);
      const isConflict = cb.checked && conflictStateSet.has(String(cb.value || '').toUpperCase());
      const isMismatch = mismatchStates.has(stateCode);
      label.classList.toggle('zip-implied', isImplied);
      label.classList.toggle('zip-mismatch', isMismatch);
      label.classList.toggle('conflict', isConflict);
    });
    if (invalidTokens.length > 0) {
      zipPreviewEl.textContent = `Invalid ZIP token(s): ${invalidTokens.join(', ')}. Use 3 or 5 digits, or a range like 900..930.`;
      zipPreviewEl.classList.add('territory-exclude');
    } else {
      const hintText = tokenHints.length > 0 ? `ZIP coverage: ${tokenHints.join(' | ')}` : 'ZIP coverage: none';
      const mismatchText =
        mismatchStates.size > 0 ? ` | Outside selected states: ${Array.from(mismatchStates).join(', ')}` : '';
      zipPreviewEl.textContent = `${hintText}${mismatchText}`;
      zipPreviewEl.classList.toggle('territory-exclude', mismatchStates.size > 0);
    }
    draftSummaryEl.textContent = `Draft: ${selectedSegments.length} segment(s), ${selectedTypes.length} type(s), ${selectedStates.size} state/province, ${includeCount} zip include, ${excludeCount} zip exclude, ${conflictDetails.length} conflict group(s).`;
    if (conflictDetails.length === 0) {
      conflictPreviewEl.textContent = 'No conflicts detected in current draft.';
      conflictPreviewEl.classList.remove('territory-exclude');
      return;
    }
    conflictPreviewEl.textContent = `Conflicts: ${conflictDetails.slice(0, 4).join(' | ')}${conflictDetails.length > 4 ? ` | +${conflictDetails.length - 4} more` : ''}`;
    conflictPreviewEl.classList.add('territory-exclude');
  };

  const loadTerritoryScope = (repId) => {
    if (!repId) return;
    clearTerritorySelections();
    const scoped = state.repTerritories.filter((t) => toPositiveInt(t.rep_id) === repId);
    const segments = Array.from(new Set(scoped.map((t) => t.segment).filter(Boolean)));
    territoryForm.querySelectorAll('input[name="segments"]').forEach((el) => {
      el.checked = segments.includes(el.value);
    });
    const customerTypes = Array.from(new Set(scoped.map((t) => t.customer_type).filter(Boolean)));
    territoryForm.querySelectorAll('input[name="customerTypes"]').forEach((el) => {
      el.checked = customerTypes.includes(el.value);
    });

    const stateIncludes = Array.from(
      new Set(scoped.filter((t) => t.territory_type === 'state' && !t.is_exclusion).map((t) => (t.state || '').toUpperCase()).filter(Boolean))
    );
    territoryForm.querySelectorAll('input[name="states"]').forEach((el) => {
      el.checked = stateIncludes.includes(el.value.toUpperCase());
    });

    const zipTokens = Array.from(
      new Set(
        scoped
          .filter((t) => t.territory_type === 'zip_prefix' || t.territory_type === 'zip_exact')
          .map((t) => `${t.is_exclusion ? '-' : ''}${t.zip_prefix || t.zip_exact || ''}`)
          .filter(Boolean)
      )
    );
    territoryForm.querySelector('[name="zipCodes"]').value = zipTokens.join(', ');
    updateTerritoryConflictHighlights();
  };

  const renderRepPickerList = () => {
    const q = String(state.territoryRepSearch || '').trim().toLowerCase();
    let candidates = state.reps
      .filter((rep) => toPositiveInt(rep.id))
      .filter((rep) => !q || String(rep.full_name || '').toLowerCase().includes(q))
      .sort((a, b) => String(a.full_name || '').localeCompare(String(b.full_name || '')));

    if (state.selectedTerritoryRepId && !candidates.some((rep) => toPositiveInt(rep.id) === state.selectedTerritoryRepId)) {
      const selectedRep = state.reps.find((rep) => toPositiveInt(rep.id) === state.selectedTerritoryRepId);
      if (selectedRep) candidates = [selectedRep, ...candidates];
    }
    candidates = candidates.slice(0, 8);

    repPickerListEl.innerHTML = candidates.length
      ? candidates
          .map((rep) => {
            const repId = toPositiveInt(rep.id);
            return `<button type="button" class="rep-picker-item ${state.selectedTerritoryRepId === repId ? 'active' : ''}" data-territory-pick-rep="${repId}">${escapeHtml(rep.full_name || '')}</button>`;
          })
          .join('')
      : '<div class="tiny">No reps found</div>';
    repPickerListEl.querySelectorAll('[data-territory-pick-rep]').forEach((btn) => {
      btn.onclick = () => {
        const repId = toPositiveInt(btn.dataset.territoryPickRep);
        if (!repId) return;
        state.selectedTerritoryRepId = repId;
        repSelectEl.value = String(repId);
        renderRepPickerList();
        loadTerritoryScope(repId);
      };
    });
  };
  repSearchPickerEl.value = state.territoryRepSearch || '';
  repSearchPickerEl.oninput = () => {
    state.territoryRepSearch = repSearchPickerEl.value || '';
    renderRepPickerList();
  };
  renderRepPickerList();
  if (state.selectedTerritoryRepId) {
    repSelectEl.value = String(state.selectedTerritoryRepId);
    loadTerritoryScope(state.selectedTerritoryRepId);
  }

  territoryForm.querySelectorAll('input[name="states"], input[name="segments"], input[name="customerTypes"]').forEach((el) => {
    el.onchange = () => updateTerritoryConflictHighlights();
  });
  zipCodesEl.oninput = () => updateTerritoryConflictHighlights();

  territoryForm.onsubmit = async (event) => {
    event.preventDefault();
    const repId = toPositiveInt(repSelectEl.value);
    const segments = getCheckedValues('segments');
    const customerTypes = getCheckedValues('customerTypes');
    const states = getCheckedValues('states');
    const zipCodes = String(zipCodesEl.value || '');
    const { invalidTokens } = parseDraftZipTokens();
    if (invalidTokens.length > 0) {
      showToast('Zip codes must be 3 or 5 digits, or a range like 900..930', true);
      return;
    }
    if (!repId) {
      showToast('Select a rep first', true);
      return;
    }
    const clearAll = segments.length === 0 && customerTypes.length === 0 && states.length === 0 && !zipCodes.trim();
    if (clearAll) {
      if (!confirm('Remove all territory assignments for this rep?')) return;
    } else if (segments.length === 0 || customerTypes.length === 0) {
      showToast('Select at least one segment and one type', true);
      return;
    }
    try {
      const result = await api('/api/rep-territories/sync', {
        method: 'POST',
        body: JSON.stringify({
          repId,
          segments,
          customerTypes,
          states,
          zipCodes,
          clearAll,
          replaceScope: true
        })
      });
      await renderRepsView();
      const created = Number.isFinite(Number(result?.created)) ? Number(result.created) : 0;
      const removed = Number.isFinite(Number(result?.removed)) ? Number(result.removed) : 0;
      showToast(`Territory scope saved (added ${created}, removed ${removed})`);
      updateTerritoryConflictHighlights();
    } catch (error) {
      if (error?.status === 409) {
        const conflicts = Array.isArray(error?.data?.conflicts) ? error.data.conflicts : [];
        const preview = conflicts
          .slice(0, 5)
          .map((c) => {
            const where = c.territoryType === 'state' ? c.state : c.zipExact || c.zipPrefix;
            return `${c.repName || `Rep #${c.repId}`} • ${c.segment}/${c.customerType} • ${c.territoryType}:${where}`;
          })
          .join('\n');
        const msg = `Conflicts found with existing assignments:\n${preview}${conflicts.length > 5 ? `\n+${conflicts.length - 5} more` : ''}\n\nOverride and save anyway?`;
        if (!confirm(msg)) return;
        try {
          const forced = await api('/api/rep-territories/sync', {
            method: 'POST',
            body: JSON.stringify({
              repId,
              segments,
              customerTypes,
              states,
              zipCodes,
              replaceScope: true,
              allowConflicts: true
            })
          });
          await renderRepsView();
          const created = Number.isFinite(Number(forced?.created)) ? Number(forced.created) : 0;
          const removed = Number.isFinite(Number(forced?.removed)) ? Number(forced.removed) : 0;
          showToast(`Saved with conflicts (added ${created}, removed ${removed})`);
          updateTerritoryConflictHighlights();
          return;
        } catch (forceError) {
          showToast(forceError.message, true);
          return;
        }
      }
      showToast(error.message, true);
    }
  };
  updateTerritoryConflictHighlights();

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
      const repId = toPositiveInt(row.dataset.openRepDetail);
      if (!repId) return;
      openRepAccounts(repId);
    };
  });

  document.querySelectorAll('[data-delete-rep]').forEach((btn) => {
    btn.onclick = async () => {
      const repId = toPositiveInt(btn.dataset.deleteRep);
      if (!repId) return;
      if (!confirm('Delete this placeholder rep?')) return;
      try {
        await api(`/api/reps/${repId}`, { method: 'DELETE' });
        await renderRepsView();
        showToast('Rep deleted');
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });

  const userCreateForm = document.getElementById('userCreateForm');
  if (userCreateForm && state.user?.role === 'admin') {
    userCreateForm.onsubmit = async (event) => {
      event.preventDefault();
      const fd = new FormData(userCreateForm);
      const fullName = String(fd.get('fullName') || '').trim();
      try {
        const created = await api('/api/users', {
          method: 'POST',
          body: JSON.stringify({
            fullName,
            email: fd.get('email'),
            role: fd.get('role'),
            phone: fd.get('phone')
          })
        });
        if (String(fd.get('role') || '') === 'rep' && toPositiveInt(created.repId)) {
          state.adminOpenSection = 'Territories';
          state.selectedTerritoryRepId = toPositiveInt(created.repId);
          state.territoryRepSearch = fullName;
        }
        await renderRepsView();
        showToast(created.emailSent ? 'User created. Invitation emailed.' : `User created. Email failed: ${created.emailError || 'unknown error'}`, !created.emailSent);
      } catch (error) {
        if (error?.status === 409 && error?.data?.code === 'USER_EXISTS_INACTIVE' && toPositiveInt(error.data.userId)) {
          const shouldReactivate = confirm(
            `${error.data.fullName || 'This user'} already exists but is inactive. Reactivate and send a new invitation email?`
          );
          if (!shouldReactivate) {
            showToast(error.data.error || 'This email belongs to an inactive user.', true);
            return;
          }
          try {
            await api(`/api/users/${toPositiveInt(error.data.userId)}`, {
              method: 'PATCH',
              body: JSON.stringify({
                isActive: true,
                role: String(fd.get('role') || error.data.role || 'viewer'),
                fullName,
                email: String(fd.get('email') || '').trim()
              })
            });
            const resend = await api(`/api/users/${toPositiveInt(error.data.userId)}/resend-invite`, { method: 'POST' });
            await renderRepsView();
            showToast(resend.emailSent ? 'User reactivated. Invitation emailed.' : `User reactivated, but email failed: ${resend.emailError || 'unknown error'}`, !resend.emailSent);
            return;
          } catch (reactivateError) {
            showToast(reactivateError.message, true);
            return;
          }
        }
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
        const result = await api(`/api/users/${userId}/resend-invite`, { method: 'POST' });
        showToast(result.emailSent ? 'Invitation emailed' : `Invite regenerated, but email failed: ${result.emailError || 'unknown error'}`, !result.emailSent);
      } catch (error) {
        showToast(error.message, true);
      }
    };
  });
}

function openRepAccounts(repId) {
  const safeRepId = toPositiveInt(repId);
  if (!safeRepId) {
    document.getElementById('repAccountsTitle').textContent = 'Accounts';
    document.getElementById('repTerritorySummaryBody').innerHTML = '<tr><td colspan="3" class="tiny">Invalid rep selection.</td></tr>';
    document.getElementById('repTerritoryMismatchBody').innerHTML = '<tr><td colspan="4" class="tiny">Invalid rep selection.</td></tr>';
    document.getElementById('repAccountsBody').innerHTML = '<tr><td colspan="4">No assigned companies.</td></tr>';
    setView('repAccountsView', 'Accounts');
    return;
  }
  const rep = state.reps.find((r) => toPositiveInt(r.id) === safeRepId);
  const territories = state.repTerritories.filter((t) => toPositiveInt(t.rep_id) === safeRepId);
  const assignedCompanyIds = new Set(state.repAssignments.filter((a) => toPositiveInt(a.rep_id) === safeRepId).map((a) => toPositiveInt(a.company_id)));
  const companiesFromTerritory = state.companies.filter((company) => companyIsInTerritory(company, territories));
  const companies = new Map();
  for (const company of companiesFromTerritory) {
    const id = toPositiveInt(company.id);
    if (!id) continue;
    companies.set(id, company);
  }
  for (const companyId of assignedCompanyIds) {
    const company = state.companies.find((c) => toPositiveInt(c.id) === companyId);
    if (company) companies.set(companyId, company);
  }
  const companyRows = Array.from(companies.values()).sort((a, b) => String(a.name || '').localeCompare(String(b.name || '')));
  const includeRules = territories.filter((t) => !t.is_exclusion);
  const mismatchRows = [];
  for (const company of state.companies) {
    const companyId = toPositiveInt(company.id);
    if (!companyId || companies.has(companyId)) continue;
    for (const rule of includeRules) {
      if (!geographyOnlyMatch(rule, company)) continue;
      const companySegment = String(company.segment || '-');
      const companyType = String(company.customer_type || '-');
      const ruleSegment = String(rule.segment || 'All Segments');
      const ruleType = String(rule.customer_type || 'All Types');
      const segmentMismatch = rule.segment && rule.segment !== company.segment;
      const typeMismatch = rule.customer_type && rule.customer_type !== company.customer_type;
      if (!segmentMismatch && !typeMismatch) continue;
      mismatchRows.push({
        companyId,
        name: company.name || '',
        state: company.state || '',
        companyPair: `${companySegment} / ${companyType}`,
        rulePair: `${ruleSegment} / ${ruleType}`
      });
      break;
    }
  }
  const uniqueMismatch = Array.from(new Map(mismatchRows.map((row) => [row.companyId, row])).values()).sort((a, b) =>
    String(a.name).localeCompare(String(b.name))
  );
  document.getElementById('repAccountsTitle').textContent = `Accounts • ${rep?.full_name || ''}`;
  if (!territories.length) {
    document.getElementById('repTerritorySummaryBody').innerHTML = '<tr><td colspan="3" class="tiny">No territories assigned</td></tr>';
  } else {
    const groupMap = new Map();
    for (const rule of territories) {
      const type = String(rule.customer_type || 'All Types');
      const segment = String(rule.segment || 'All Segments');
      const key = `${type}||${segment}`;
      if (!groupMap.has(key)) {
        groupMap.set(key, {
          type,
          segment,
          states: new Set(),
          cityStates: new Set(),
          zips: new Set()
        });
      }
      const group = groupMap.get(key);
      if (rule.territory_type === 'state' && rule.state) {
        group.states.add(String(rule.state).toUpperCase());
      }
      if (rule.territory_type === 'city_state' && (rule.city || rule.state)) {
        group.cityStates.add(`${String(rule.city || '').trim()}, ${String(rule.state || '').trim()}`.replace(/^,\s*/, '').trim());
      }
      if (rule.territory_type === 'zip_prefix' || rule.territory_type === 'zip_exact') {
        const zip = String(rule.zip_prefix || rule.zip_exact || '').replace(/\D/g, '');
        if (zip) group.zips.add(`${rule.is_exclusion ? '-' : ''}${zip}`);
      }
    }

    const rows = Array.from(groupMap.values())
      .map((group) => {
        const territoryParts = [
          ...Array.from(group.states).sort(),
          ...Array.from(group.cityStates).sort(),
          ...Array.from(group.zips).sort()
        ];
        return {
          type: group.type,
          segment: group.segment,
          territories: territoryParts.join(', ') || '-'
        };
      })
      .sort((a, b) => {
        if (a.type === b.type) return a.segment.localeCompare(b.segment);
        return a.type.localeCompare(b.type);
      });

    let lastType = null;
    document.getElementById('repTerritorySummaryBody').innerHTML = rows
      .map((row) => {
        const showType = row.type !== lastType;
        lastType = row.type;
        return `<tr>
          <td>${showType ? escapeHtml(row.type) : ''}</td>
          <td>${escapeHtml(row.segment)}</td>
          <td>${escapeHtml(row.territories)}</td>
        </tr>`;
      })
      .join('');
  }
  document.getElementById('repAccountsBody').innerHTML = companyRows.length
    ? companyRows
        .map(
          (c) => `<tr class="clickable" data-open-company-from-rep="${toPositiveInt(c.id)}">
            <td>${escapeHtml(c.name || '')}</td>
            <td>${escapeHtml(c.city || '')}</td>
            <td>${escapeHtml(c.state || '')}</td>
            <td>${escapeHtml(c.zip || '')}</td>
          </tr>`
        )
        .join('')
    : '<tr><td colspan="4">No companies match current territory rules.</td></tr>';
  document.getElementById('repTerritoryMismatchBody').innerHTML = uniqueMismatch.length
    ? uniqueMismatch
        .map(
          (row) => `<tr class="clickable" data-open-company-from-mismatch="${row.companyId}">
            <td>${escapeHtml(row.name)}</td>
            <td>${escapeHtml(row.state)}</td>
            <td>${escapeHtml(row.companyPair)}</td>
            <td>${escapeHtml(row.rulePair)}</td>
          </tr>`
        )
        .join('')
    : '<tr><td colspan="4" class="tiny">No mismatch companies.</td></tr>';

  document.querySelectorAll('[data-open-company-from-rep]').forEach((row) => {
    row.onclick = () => openCompany(Number(row.dataset.openCompanyFromRep));
  });
  document.querySelectorAll('[data-open-company-from-mismatch]').forEach((row) => {
    row.onclick = () => openCompany(Number(row.dataset.openCompanyFromMismatch));
  });
  setView('repAccountsView', `Accounts • ${rep?.full_name || ''}`);
}

function defaultActivityReportStartIso() {
  const d = new Date();
  d.setDate(d.getDate() - 7);
  return d.toISOString().slice(0, 10);
}

function defaultActivityReportEndIso() {
  return new Date().toISOString().slice(0, 10);
}

async function openWeeklyReportView() {
  const form = document.getElementById('weeklyReportForm');
  const reportBody = document.getElementById('weeklyReportBody');
  const reportMeta = document.getElementById('weeklyReportMeta');
  if (!form || !reportBody || !reportMeta) return;

  form.innerHTML = `
    <label><span class="sr-only">Start Date</span><input name="startDate" type="date" value="${escapeHtml(
      state.weeklyReport?.startDate || defaultActivityReportStartIso()
    )}" /></label>
    <label><span class="sr-only">End Date</span><input name="endDate" type="date" value="${escapeHtml(
      state.weeklyReport?.endDate || defaultActivityReportEndIso()
    )}" /></label>
    <label><span class="sr-only">Segment</span><select name="segment"><option value="">All segments</option>${state.segments
      .map((x) => `<option value="${escapeHtml(x)}">${escapeHtml(x)}</option>`)
      .join('')}</select></label>
    <label><span class="sr-only">Type</span><select name="customerType"><option value="">All types</option>${state.customerTypes
      .map((x) => `<option value="${escapeHtml(x)}">${escapeHtml(x)}</option>`)
      .join('')}</select></label>
    <label><span class="sr-only">Rep</span><select name="repId"><option value="">All reps</option>${state.reps
      .map((r) => `<option value="${toPositiveInt(r.id)}">${escapeHtml(r.full_name || '')}</option>`)
      .join('')}</select></label>
    <button type="submit">Run</button>
  `;

  const renderReport = async () => {
    const fd = new FormData(form);
    const params = new URLSearchParams();
    params.set('startDate', String(fd.get('startDate') || defaultActivityReportStartIso()));
    params.set('endDate', String(fd.get('endDate') || defaultActivityReportEndIso()));
    if (String(fd.get('segment') || '')) params.set('segment', String(fd.get('segment')));
    if (String(fd.get('customerType') || '')) params.set('customerType', String(fd.get('customerType')));
    if (String(fd.get('repId') || '')) params.set('repId', String(fd.get('repId')));
    const data = await api(`/api/reports/activity?${params.toString()}`);
    state.weeklyReport = data;
    reportMeta.textContent = `Range: ${data.startDate} to ${data.endDate}`;
    const reps = Array.isArray(data.reps) ? data.reps : [];
    reportBody.innerHTML = reps.length
      ? reps
          .map(
            (rep) => `<section class="report-rep-page">
          <h3>${escapeHtml(rep.repName || '')}</h3>
          <h4>Interactions</h4>
          <table>
            <thead><tr><th>Date</th><th>Company</th><th>Contact(s)</th><th>Notes</th></tr></thead>
            <tbody>
              ${
                (rep.lastWeekInteractions || []).length
                  ? rep.lastWeekInteractions
                      .map(
                        (row) => `<tr><td>${escapeHtml(row.date || '')}</td><td>${escapeHtml(row.companyName || '')}</td><td>${escapeHtml(
                          row.contacts || '-'
                        )}</td><td>${escapeHtml(row.notes || '')}</td></tr>`
                      )
                      .join('')
                  : '<tr><td colspan="4" class="tiny">No interactions</td></tr>'
              }
            </tbody>
          </table>
          <h4>Follow-ups</h4>
          <table>
            <thead><tr><th>Date</th><th>Company</th><th>Contact(s)</th><th>Next Action</th></tr></thead>
            <tbody>
              ${
                (rep.upcomingFollowUps || []).length
                  ? rep.upcomingFollowUps
                      .map(
                        (row) => `<tr><td>${escapeHtml(row.date || '')}</td><td>${escapeHtml(row.companyName || '')}</td><td>${escapeHtml(
                          row.contacts || '-'
                        )}</td><td>${escapeHtml(row.nextAction || '')}</td></tr>`
                      )
                      .join('')
                  : '<tr><td colspan="4" class="tiny">No follow-ups</td></tr>'
              }
            </tbody>
          </table>
        </section>`
          )
          .join('')
      : '<div class="tiny">No reps in scope for this report.</div>';
  };

  form.onsubmit = async (event) => {
    event.preventDefault();
    await renderReport();
  };
  await renderReport();
  setView('weeklyReportView', 'Activity Report');
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
    els.weeklyReportBtn.classList.toggle('hidden', !canWrite());
    els.manageRepsBtn.classList.toggle('hidden', !canManageReps());
    els.feedbackBtn.classList.remove('hidden');
    document.getElementById('showCreateCompanyBtn').classList.toggle('hidden', !canWrite());

    await Promise.all([loadCompanies(), loadReps(), loadMetadata(), loadTheme()]);
    try {
      const companySettingsData = await api('/api/settings/company');
      state.companySettings = companySettingsData.settings || state.companySettings;
    } catch {
    }
    applyHeaderBranding();
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
  const forgotForm = document.getElementById('forgotPasswordForm');
  const resetForm = document.getElementById('resetPasswordForm');
  const bootstrapForm = document.getElementById('bootstrapForm');
  const url = new URL(window.location.href);
  const inviteToken = url.searchParams.get('invite');
  const resetToken = url.searchParams.get('reset');

  const showLoginOnly = () => {
    form.classList.add('hidden');
    resetForm.classList.add('hidden');
    loginForm.classList.remove('hidden');
    forgotForm.classList.add('hidden');
    bootstrapForm.classList.add('hidden');
  };

  if (!inviteToken && !resetToken) {
    showLoginOnly();
    return;
  }

  form.classList.toggle('hidden', !inviteToken);
  resetForm.classList.toggle('hidden', !resetToken);
  loginForm.classList.add('hidden');
  forgotForm.classList.add('hidden');
  bootstrapForm.classList.add('hidden');
  form.querySelector('[name="email"]').value = '';
  resetForm.querySelector('[name="email"]').value = '';

  if (inviteToken) {
    api(`/api/auth/invite/${encodeURIComponent(inviteToken)}`)
      .then((data) => {
        form.querySelector('[name="email"]').value = data.email || '';
      })
      .catch((error) => {
        showToast(error.message, true);
      });
  }

  if (resetToken) {
    api(`/api/auth/password-reset/${encodeURIComponent(resetToken)}`)
      .then((data) => {
        resetForm.querySelector('[name="email"]').value = data.email || '';
      })
      .catch((error) => {
        showToast(error.message, true);
      });
  }

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
      showLoginOnly();
      showToast('Password saved. You can sign in now.');
    } catch (error) {
      showToast(error.message, true);
    }
  };

  resetForm.onsubmit = async (event) => {
    event.preventDefault();
    const fd = new FormData(resetForm);
    const password = String(fd.get('password') || '');
    const confirmPassword = String(fd.get('confirmPassword') || '');
    if (password !== confirmPassword) {
      showToast('Passwords do not match', true);
      return;
    }
    try {
      await api('/api/auth/password-reset/confirm', {
        method: 'POST',
        body: JSON.stringify({ token: resetToken, password })
      });
      url.searchParams.delete('reset');
      window.history.replaceState({}, '', url.toString());
      resetForm.reset();
      showLoginOnly();
      showToast('Password reset. You can sign in now.');
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

document.getElementById('showForgotPasswordBtn').onclick = () => {
  document.getElementById('loginForm').classList.add('hidden');
  document.getElementById('bootstrapForm').classList.add('hidden');
  document.getElementById('inviteSetupForm').classList.add('hidden');
  document.getElementById('resetPasswordForm').classList.add('hidden');
  document.getElementById('forgotPasswordForm').classList.remove('hidden');
};

document.getElementById('cancelForgotPasswordBtn').onclick = () => {
  document.getElementById('forgotPasswordForm').classList.add('hidden');
  document.getElementById('loginForm').classList.remove('hidden');
};

document.getElementById('forgotPasswordForm').onsubmit = async (event) => {
  event.preventDefault();
  const fd = new FormData(event.target);
  try {
    const result = await api('/api/auth/password-reset/request', {
      method: 'POST',
      body: JSON.stringify({ email: fd.get('email') })
    });
    showToast(result.message || 'If that email is active in the CRM, a password reset link has been sent.');
    event.target.reset();
    document.getElementById('forgotPasswordForm').classList.add('hidden');
    document.getElementById('loginForm').classList.remove('hidden');
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
  els.weeklyReportBtn.classList.add('hidden');
  els.manageRepsBtn.classList.add('hidden');
  els.feedbackBtn.classList.add('hidden');
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
    state.territoryRepSearch = '';
    state.selectedTerritoryRepId = 0;
    await renderRepsView();
  } catch (error) {
    showToast(error.message, true);
  }
};

els.feedbackBtn.onclick = async () => {
  try {
    await openFeedbackView();
  } catch (error) {
    showToast(error.message, true);
  }
};

els.weeklyReportBtn.onclick = async () => {
  try {
    await openWeeklyReportView();
  } catch (error) {
    showToast(error.message, true);
  }
};

document.getElementById('printWeeklyReportBtn').onclick = () => window.print();

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
  state.companyPage = 1;
  loadCompanies();
};

document.getElementById('due14FilterBtn').onclick = async () => {
  state.companyDue14Only = !state.companyDue14Only;
  state.companyPage = 1;
  await loadCompanies();
};

document.getElementById('pendingInteractionFilterBtn').onclick = async () => {
  state.companyPendingOnly = !state.companyPendingOnly;
  state.companyPage = 1;
  await loadCompanies();
};

document.getElementById('companySortSelect').onchange = async (event) => {
  state.companySortBy = event.target.value || 'name';
  state.companyPage = 1;
  await loadCompanies();
};

document.getElementById('companySortDirSelect').onchange = async (event) => {
  state.companySortDir = event.target.value || 'asc';
  state.companyPage = 1;
  await loadCompanies();
};

document.getElementById('companyPrevPageBtn').onclick = async () => {
  if (state.companyPage <= 1) return;
  state.companyPage -= 1;
  await loadCompanies();
};

document.getElementById('companyNextPageBtn').onclick = async () => {
  const totalPages = Math.max(1, Math.ceil((state.companyRowsTotal || 0) / state.companyPageSize));
  if (state.companyPage >= totalPages) return;
  state.companyPage += 1;
  await loadCompanies();
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
