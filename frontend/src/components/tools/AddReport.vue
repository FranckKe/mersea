<template>
  <div class="add-report-layer-tool">
    <div class="steps" id="addReportSteps">
      <div class="step-item is-active is-success">
        <div class="step-marker">1</div>
        <div class="step-details">
          <p class="step-title">{{ $t('report') }}</p>
        </div>
      </div>
      <div class="step-item">
        <div class="step-marker">2</div>
        <div class="step-details">
          <p class="step-title">{{ $tc('tracers', '1') }}</p>
        </div>
      </div>
      <form class="add-report-form">
        <div class="steps-content">
          <div class="step-content">
            <b-field
              label="coordinates"
              class="hidden"
              :type="errors.has('coordinates') ? 'is-danger' : ''"
              :message="
                errors.has('coordinates') ? errors.first('coordinates') : ''
              "
            >
              <b-input v-model="coordinates" type="text" name="coordinates" v-validate="'required'"></b-input>
            </b-field>
            <b-field
              :label="$t('address')"
              :type="errors.has('address') ? 'is-danger' : ''"
              :message="errors.has('address') ? errors.first('address') : ''"
            >
              <b-input
                custom-class="address"
                v-model="address"
                type="text"
                name="address"
                :data-vv-as="$t('address') | lowercase"
                v-validate="'required'"
                disabled="true"
                expanded
              ></b-input>
            </b-field>
            <b-message type="is-info">{{ $t('click_map') }}</b-message>
            <b-field
              v-show="!this.$auth.check()"
              :label="$t('name_pseudo')"
              :type="errors.has('username') ? 'is-danger' : ''"
              :message="errors.has('username') ? errors.first('username') : ''"
            >
              <b-input
                v-model="username"
                name="username"
                :data-vv-as="$t('name_pseudo') | lowercase"
                v-validate="'required'"
              ></b-input>
            </b-field>
            <b-field
              class="file"
              :label="$t('photo')"
              :type="errors.has('file') ? 'is-danger' : ''"
              :message="errors.has('file') ? errors.first('file') : ''"
              v-if="this.$auth.user() && !this.$auth.user().senior"
            >
              <b-upload
                v-model="file"
                name="file"
                :data-vv-as="$t('photo') | lowercase"
                v-validate="'required|size:4000'"
              >
                <a class="button is-primary">
                  <b-icon icon="upload"></b-icon>
                  <span>{{ $t('upload') }}</span>
                </a>
              </b-upload>
              <span class="file-name" v-if="file">{{ file.name }}</span>
            </b-field>
            <b-message type="is-info" class="file-multiple-tracer">
              {{
              $t('photo_multiple_tracer')
              }}
            </b-message>
            <b-field
              :label="$t('report_date')"
              :type="errors.has('reportDate') ? 'is-danger' : ''"
              :message="
                errors.has('reportDate') ? errors.first('reportDate') : ''
              "
            >
              <b-datepicker
                v-model="reportDate"
                name="reportDate"
                placeholder="$t('click_select')"
                :month-names="monthNames"
                :day-names="dayNames"
                :first-day-of-week="firstDayOfTheWeek"
                :max-date="new Date()"
                :data-vv-as="$t('report_date') | lowercase"
                v-validate="'required'"
              ></b-datepicker>
            </b-field>
            <b-field
              :label="`${$t('description')} (${$t('optional')})`"
              class="description-field"
              :type="errors.has('description') ? 'is-danger' : ''"
              :message="
                errors.has('description') ? errors.first('description') : ''
              "
            >
              <b-input
                class="description"
                v-model="description"
                name="description"
                maxlength="300"
                type="textarea"
                :data-vv-as="$t('description') | lowercase"
                v-validate="'max:300'"
              ></b-input>
            </b-field>
            <b-message type="is-info" v-if="!this.$auth.check()">
              {{
              $t('why_account')
              }}
            </b-message>
          </div>
          <div class="step-content">
            <b-message
              v-for="(addReportError, index) in addReportsErrors"
              class="submit-form-error"
              :key="'reportError' + index"
              v-show="addReportError !== ''"
              type="is-danger"
            >
              {{ addReportError }}
              <ul>
                <li
                  v-for="(addReportValidationError,
                  index) in addReportsValidationErrors[index]"
                  :key="index"
                >- {{ addReportValidationError.metadata.reason }}</li>
              </ul>
            </b-message>
            <div v-for="(tracer, index) in selectedTracers" :key="index">
              <b-field grouped>
                <b-field
                  :label="index === 0 ? '-' : ''"
                  :class="{ 'is-label-hidden': index === 0 }"
                  custom-class="remove-tracer-input-label"
                >
                  <a
                    @click="removeTracerInput(index)"
                    class="button is-danger is-outlined"
                    :disabled="
                      selectedTracers.length === 1 ||
                        areSubmitting[index] ||
                        areSomeReportsSubmitted
                    "
                  >
                    <b-icon icon="times" />
                  </a>
                </b-field>
                <b-field
                  :label="index === 0 ? $tc('tracers', 1) : ''"
                  :type="errors.has(`tracer-${index}`) ? 'is-danger' : ''"
                  :message="
                    errors.has(`tracer-${index}`)
                      ? errors.first(`tracer-${index}`)
                      : ''
                  "
                  expanded
                >
                  <b-autocomplete
                    v-model="tracerNames[index]"
                    class="tracers-autocomplete"
                    :name="`tracer-${index}`"
                    :open-on-focus="true"
                    :data="
                      tracers.filter(
                        t =>
                          t.name
                            .toString()
                            .toLowerCase()
                            .indexOf(tracerNames[index].toLowerCase()) >= 0 &&
                          t.category !== 'archive'
                      )
                    "
                    field="name"
                    @select="option => (selectedTracers[index] = option)"
                    :placeholder="$t('search_tracers')"
                    :data-vv-as="$tc('tracers', 1) | lowercase"
                    v-validate="'required'"
                    customClass="tracer-input"
                    ref="tracer-input"
                  >
                    <template slot-scope="props">
                      <div class="media">
                        <div class="media-left">
                          <img class="image is-64x64" :src="`${apiUrl}${props.option.photo}`" />
                        </div>
                        <div class="media-content">
                          <p class="autocomplete-tracer-name">{{ props.option.name }}</p>
                          <small>{{ props.option.kind }}</small>
                        </div>
                      </div>
                    </template>
                    <template slot="empty">{{ $t('no_results') }}</template>
                  </b-autocomplete>
                </b-field>
                <b-field
                  class="quantity-field"
                  :label="index === 0 ? $t('quantity') : ''"
                  :type="errors.has('quantity') ? 'is-danger' : ''"
                  :message="
                    errors.has('quantity') ? errors.first('quantity') : ''
                  "
                >
                  <b-input
                    v-model="quantities[index]"
                    name="quantity"
                    type="number"
                    step="1"
                    min="0"
                    :data-vv-as="$t('quantity') | lowercase"
                    v-validate="'required|min_value:0'"
                  ></b-input>
                </b-field>
                <b-field
                  :label="index === 0 ? '-' : ''"
                  :class="{ 'is-label-hidden': index === 0 }"
                  customClass="remove-tracer-input-label"
                >
                  <span
                    @click="retrySubmitReport(index)"
                    :class="{
                      'report-submission-status': true,
                      'report-submission-status--clickable':
                        getSubmissionStatus(index) === 'failed',
                      'has-text-success':
                        getSubmissionStatus(index) === 'saved',
                      'button is-primary is-outlined':
                        getSubmissionStatus(index) === 'failed'
                    }"
                    :disabled="!(getSubmissionStatus(index) === 'failed')"
                  >
                    <b-icon
                      :icon="getSubmissionStatusIcon(index)"
                      :custom-class="
                        getSubmissionStatus(index) === 'submitting'
                          ? 'fa-spin'
                          : ''
                      "
                    />
                  </span>
                </b-field>
              </b-field>
            </div>
            <b-field class="add-tracer-field">
              <a
                class="button is-primary add-tracer-input"
                @click="addTracerInput"
                :disabled="
                  selectedTracers.length >= this.tracerInputsLimit ||
                    !selectedTracers[selectedTracers.length - 1] ||
                    !selectedTracers[selectedTracers.length - 1].id ||
                    areSomeReportsSubmitted
                "
              >
                <b-icon icon="plus"></b-icon>
              </a>
            </b-field>
            <b-message
              v-if="!anySubmitFailed"
              type="is-success"
              aria-close-label="Close message"
            >{{ $t('report_review') }}</b-message>
          </div>
        </div>
      </form>
      <div class="steps-actions">
        <div class="steps-action">
          <a
            href="#"
            id="prevAction"
            data-nav="previous"
            class="button is-light"
            :disabled="areSomeReportsSubmitting || areSomeReportsSubmitted"
          >{{ $t('previous') }}</a>
        </div>
        <div class="steps-action">
          <button
            href="#"
            id="nextAction"
            data-nav="next"
            class="button"
            :class="{
              'is-success': currentStep === 0 || currentStep === 1,
              hidden: currentStep === 1 && this.areAllReportsSubmitted,
              'is-loading': currentStep === 1 && this.areSomeReportsSubmitting
            }"
            disabled="false"
          >{{ currentStep === 1 ? $t('submit') : $t('next') }}</button>
          <a
            href="#"
            class="button is-danger close-button-step"
            :class="{ hidden: currentStep !== 1 || !areAllReportsSubmitted }"
            @click="closeAddReportForm"
          >{{ $t('close') }}</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const addReportModule = createNamespacedHelpers('addReport')
const tracersModule = createNamespacedHelpers('tracers')
const toolBarModule = createNamespacedHelpers('toolBar')

import bulmaSteps from 'bulma-steps'
import moment from 'moment'

export default {
  name: 'addReport',
  props: {
    mapGeolocationControl: undefined
  },
  created() {
    // The limit of tracers for bulk reporting
    this.tracerInputsLimit = 8
  },
  data() {
    return {
      apiUrl: this.$apiUrl,
      tracers: [],
      selectedTracers: [{}],
      areSubmitting: [false],
      areSubmitted: [false],
      file: null,
      isSaved: [false],
      quantities: [1],
      tracerNames: [''],
      username: this.$auth.check() ? this.$auth.user().name : '',
      description: '',
      reportDate: new Date(),
      addReportsErrors: [],
      addReportsValidationErrors: [],
      bulmaSteps: {},
      monthNames: moment.months(),
      dayNames: moment.weekdaysShort(),
      firstDayOfTheWeek: moment().weekday() === 1 ? 0 : 1
    }
  },
  mounted() {
    moment.locale(this.$i18n.locale)
    if (this.$auth.check()) this.username = this.$auth.user().name

    this.tracers = this.getTracers()
    this.bulmaSteps = new bulmaSteps(
      document.getElementById('addReportSteps'),
      {
        beforeNext: step => {
          return new Promise((resolve, reject) => {
            if (step === 0) {
              let validatefile = new Promise(resolve => resolve(true))

              // The 'file' field does not always exist depending if the user is senior or not
              // vee-validate complains when it does not exist
              if (
                !this.$auth.check() ||
                (this.$auth.user() && !this.$auth.user().senior)
              ) {
                validatefile = this.$validator.validate('file')
              }

              return Promise.all([
                this.$validator.validate('coordinates'),
                this.$validator.validate('address'),
                this.$validator.validate('username'),
                this.$validator.validate('reportDate'),
                this.$validator.validate('description'),
                validatefile
              ])
                .then(validation => {
                  validation.some(v => v) &&
                    (document.querySelector('.tool-view').scrollTop = 0)
                  resolve(validation.every(v => v))
                })
                .catch(error => console.error(error))
            }

            if (step === 1) {
              return this.$validator
                .validateAll()
                .then(validateForm => {
                  if (this.areAllReportsSubmitted) {
                    resolve(true)
                  } else if (validateForm) {
                    return this.submitReports()
                  } else {
                    console.warn(this.$validator.errors)
                    console.warn(this.$validator.fields)
                    reject(false)
                  }
                })
                .catch(error => console.error(error))
            }

            resolve(true)
          })
        },
        onShow: step => {
          return new Promise(resolve => {
            this.currentStep = step
            resolve(true)
          })
        }
      }
    )
  },
  methods: {
    ...addReportModule.mapMutations([
      'setCoordinates',
      'setAddress',
      'setCurrentStep'
    ]),
    ...addReportModule.mapGetters([
      'getCoordinates',
      'getAddress',
      'getCurrentStep'
    ]),
    ...tracersModule.mapGetters(['getTracers']),
    ...tracersModule.mapActions(['loadTracers']),
    ...toolBarModule.mapActions(['closeToolbar']),
    async submitReports() {
      this.addReportsErrors = []
      this.addReportsValidationErrors = []

      const promises = []
      for (let index = 0; index < this.selectedTracers.length; index++) {
        const promise = this.submitReport(index)
        promises.push(promise)
      }

      try {
        await Promise.all(promises)
        return true
      } catch (e) {
        console.warn(e)
        return false
      }
    },
    async submitReport(index) {
      this.areSubmitting.splice(index, 1, true)
      this.areSubmitted.splice(index, 1, false)

      try {
        await this.submitReportPromise(index)

        this.isSaved.splice(index, 1, true)
        this.addReportsErrors.splice(index, 1)
        this.addReportsValidationErrors.splice(index, 1)
      } catch (e) {
        if ((((e || {}).response || {}).data || {}).errors != null) {
          this.addReportsValidationErrors.splice(
            index,
            1,
            e.response.data.errors
          )
        }

        this.addReportsErrors.splice(index, 1, this.$t('submit_report_failure'))
        this.isSaved.splice(index, 1, false)
      }

      this.areSubmitting.splice(index, 1, false)
      this.areSubmitted.splice(index, 1, true)
    },
    async submitReportPromise(index) {
      let file64 = null

      if (this.file != null) {
        try {
          file64 = await this.getBase64(this.file)
        } catch (e) {
          console.warn(e)
        }
      }
      const postDataJson = {
        name: this.$auth.check() ? this.$auth.user().name : this.username,
        address: this.address,
        latitude: parseFloat(this.coordinates.split(',')[0]).toFixed(4),
        longitude: parseFloat(this.coordinates.split(',')[1]).toFixed(4),
        reported_at: String(moment(this.reportDate).format('YYYY-MM-DD')),
        tracer_id: (this.selectedTracers[index] || {}).id,
        quantity: this.quantities[index],
        description: this.description
      }
      if (file64 != null) postDataJson.photo = file64

      return this.$http({
        method: 'POST',
        url: `/reports`,
        data: postDataJson,
        timeout: 60000
      })
    },
    getBase64(file) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader()
        reader.readAsDataURL(file)
        reader.onload = () => resolve(reader.result)
        reader.onerror = error => reject(error)
      })
    },
    closeAddReportForm() {
      if (
        this.bulmaSteps.get_current_step_id() === 1 &&
        this.areAllReportsSubmitted
      ) {
        this.resetForm()
      }
    },
    resetForm() {
      this.closeToolbar()
      this.address = ''
      this.coordinates = ''
      this.description = ''
      this.file = null
      this.areSubmitting = [false]
      this.areSubmitted = [false]
      this.addReportsErrors = []
      this.addReportsValidationErrors = []
      this.isSaved = [false]
      this.photo = ''
      this.quantities = [1]
      this.reportDate = new Date()
      this.selectedTracers = [{}]
      this.tracerNames = ['']
      this.username = this.$auth.check() ? this.$auth.user().name : ''
      this.$validator.reset()
      for (let i = 0; i < this.currentStep + 1; i++) {
        this.bulmaSteps.previous_step()
      }
    },
    removeTracerInput(index) {
      if (
        this.selectedTracers.length === 1 ||
        this.areSubmitting[index] ||
        this.areSomeReportsSubmitted
      )
        return false
      this.areSubmitted.splice(index, 1)
      this.areSubmitting.splice(index, 1)
      this.quantities.splice(index, 1)
      this.selectedTracers.splice(index, 1)
      this.tracerNames.splice(index, 1)
    },
    addTracerInput() {
      if (
        this.selectedTracers.length >= this.tracerInputsLimit ||
        !this.selectedTracers[this.selectedTracers.length - 1] ||
        !this.selectedTracers[this.selectedTracers.length - 1].id ||
        this.areSomeReportsSubmitted
      ) {
        return false
      }
      this.selectedTracers.push({})
      this.quantities.push(1)
      this.tracerNames.push('')
      this.areSubmitting.push(false)
      this.areSubmitted.push(false)
    },
    getSubmissionStatusIcon(index) {
      switch (this.getSubmissionStatus(index)) {
        case 'failed':
          return 'redo'
        case 'saved':
          return 'check'
        case 'submitting':
          return 'spinner'
        default:
          return ''
      }
    },
    getSubmissionStatus(index) {
      return !this.areSubmitting[index]
        ? this.areSubmitted[index]
          ? this.isSaved[index]
            ? 'saved'
            : 'failed'
          : ''
        : 'submitting'
    },
    async retrySubmitReport(index) {
      if (this.getSubmissionStatus(index) !== 'failed') return false
      try {
        await this.submitReport(index)
      } catch (e) {
        console.warn(e)
      }
    }
  },
  computed: {
    ...addReportModule.mapState({
      coordinates: state => state.coordinates
    }),
    coordinates: {
      set(value) {
        this.setCoordinates(value)
      },
      get() {
        return this.getCoordinates()
      }
    },
    ...addReportModule.mapState({
      currentStep: state => state.currentStep
    }),
    currentStep: {
      set(value) {
        this.setCurrentStep(value)
      },
      get() {
        return this.getCurrentStep()
      }
    },
    address: {
      set(value) {
        this.setAddress(value)
      },
      get() {
        return this.getAddress()
      }
    },
    areAllReportsSubmitted: function() {
      return this.areSubmitted.every(isSubmitted => isSubmitted)
    },
    areSomeReportsSubmitted: function() {
      return this.areSubmitted.some(isSubmitted => isSubmitted)
    },
    areSomeReportsSubmitting: function() {
      return this.areSubmitting.some(isSubmitting => isSubmitting)
    },
    anySubmitFailed: function() {
      return this.isSaved.some(v => v === false)
    }
  },
  watch: {
    '$i18n.locale': function() {
      moment.locale(this.$i18n.locale)
      this.monthNames = moment.months()
      this.dayNames = moment.weekdaysShort()
      this.firstDayOfTheWeek = moment().weekday() === 1 ? 0 : 1
    },
    isSaved: function() {
      if (!this.anySubmitFailed) this.bulmaSteps.next_step()
    }
  }
}
</script>

<style lang="scss" scoped>
.add-report-layer-tool {
  .field.file {
    margin-top: 0;
    flex-wrap: wrap;
    margin-bottom: 0;

    label.label {
      width: 100%;
    }

    .file-name {
      border-width: 1px 1px 1px 1px;
      margin-bottom: 0.75rem;
    }
  }

  .steps {
    flex-grow: 1;
    margin-top: 1rem;
  }

  .description-field {
    display: flex;
    flex-direction: column;
  }

  .description text-area {
    white-space: pre-wrap;
  }
}

.add-report-form {
  display: flex;
  flex-basis: 100%;
  flex-direction: column;
  padding-right: 1rem;

  & >>> .remove-tracer-input-label {
    color: white;
  }

  & >>> .tracer-input {
    padding-right: 2.25em;
  }
}

.add-report-layer .add-report-button {
  bottom: 33px;
  position: absolute;
  right: 65px;
}

.add-report-layer-tool .step-content > .field.add-tracer-field {
  text-align: center;
  margin-top: 0;
}

.close-icon {
  align-self: flex-end;
}

.geolocation-button {
  height: 36px;
  width: 36px;
}

.hidden {
  display: none !important;
}

.report-submission-status {
  display: flex;
  justify-content: center;
  width: 36px;

  &--clickable {
    cursor: pointer;
  }

  & > .icon {
    height: 36px;
  }
}

.submit-form-error ul li {
  margin-left: 15px;
}

.title-wrapper {
  align-items: center;
  display: flex;
  justify-content: space-between;
  margin-bottom: 25px;

  & .title {
    margin-bottom: 0;
  }

  & .close-button {
    align-self: flex-start;
    width: 35px;
  }
}

.upload .button {
  margin-bottom: 0.75rem;
}

.quantity-field {
  width: 75px;
}
</style>

<style>
.steps .add-report-form .steps-content {
  margin-top: 1rem;
}

.add-report-layer-tool {
  margin-top: 1rem;
}

.add-report-form .datepicker.control {
  text-align: center;
}

.add-report
  .dropdown
  .datepicker-header
  .pagination-list
  .field
  .control
  .select
  select {
  text-transform: capitalize;
}

.add-report .dropdown .datepicker-cell {
  text-transform: capitalize;
}

/* Autocomplete */
.autocomplete .dropdown-item {
  padding-right: 1rem;
}

.add-report .autocomplete-tracer-name {
  max-width: 200px;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

.is-label-hidden label.label {
  visibility: hidden;
}

.add-report-layer-tool .message {
  margin-bottom: 0;
}

.add-report-layer-tool .step-content > .field {
  margin-top: 1rem;
}

.add-report-layer-tool .field.file label {
  width: 100%;
}

.add-report-layer-tool .field .input.address {
  color: #292929;
}

.field.file p.help.is-danger {
  flex-basis: 100%;
  margin-top: 0;
  margin-bottom: 0.75rem;
  margin-left: 0;
  padding-top: 0;
}
</style>

<i18n>
{
  "en": {
    "report_verb": "Report",
    "add_report": "Report a waste",
    "address": "Address",
    "cancel_report": "Close reporting",
    "click_select": "Click to select",
    "close": "Close",
    "description": "Description",
    "done": "Done",
    "get_current_position_failure": "Failed to retrieve your current position. Make sure your GPS is enabled and that you authorize Ocean Plastic Tracker to access it.",
    "location": "Location",
    "name_pseudo": "Name or pseudo",
    "next": "Next",
    "no_results": "No results found",
    "optional": "optional",
    "previous": "Previous",
    "quantity": "Quantity",
    "report_date": "Date of report",
    "report_review": "Thank you for your report. It will soon be reviewed by an administrator",
    "report": "Report",
    "submit": "Submit",
    "search_tracers": "Search for a tracer. Ex: Bouchon, cartouche, ...",
    "click_map": "Click or drag the marker to geolocate your report.",
    "tracers": "Tracer | Tracers",
    "submit_report_failure": "Fail to submit report",
    "photo": "Photo",
    "upload": "Click to upload",
    "photo_multiple_tracer": "A photo can contain multiple tracers",
    "load_tracers_failure": "Fail to load tracers",
    "why_account": "You can create an account to manage your reports and have your name pre-filled."
  },
  "fr": {
    "report_verb": "Signaler",
    "add_report": "Signaler un déchet",
    "address": "Adresse",
    "cancel_report": "Fermer l'ajout de signalement",
    "click_select": "Cliquez pour sélectionner",
    "close": "Fermer",
    "description": "Description",
    "done": "Fin",
    "get_current_position_failure": "Échec de la localisation. Assurez-vous d'avoir activé le GPS et d'avoir autorisé Ocean Plastic Tracker à accéder à votre position.",
    "location": "Localisation",
    "name_pseudo": "Nom ou pseudo",
    "next": "Suivant",
    "no_results": "Aucun résultats",
    "optional": "optionnel",
    "previous": "Précédent",
    "quantity": "Quantité",
    "report_date": "Date de signalement",
    "report_review": "Merci pour votre signalement. Une validation va bientôt être effectuée.",
    "report": "Signalement",
    "submit": "Soumettre",
    "search_tracers": "Rechercher un tracer. Ex: Bouchon, cartouche, ...",
    "click_map": "Cliquez ou glissez le marqueur pour géolocaliser votre témoignage.",
    "tracers": "Traceur | Traceurs",
    "submit_report_failure": "Échec d'ajout d'un signalement",
    "photo": "Photo",
    "upload": "Télécharger",
    "photo_multiple_tracer": "Une photo peut contenir plusieurs tracers",
    "load_tracers_failure": "Échec de chargement des tracers",
    "why_account": "Vous pouvez créer un compte pour gérer vos signalements et avoir votre nom pré-rempli."
  },
  "es": {
    "report_verb": "Informe",
    "add_report": "Reportar un desperdicio",
    "address": "Dirección",
    "cancel_report": "Cerrar agrega testimonio",
    "click_select": "Clic para seleccionar",
    "close": "Cerrar",
    "description": "Descripción",
    "done": "Final",
    "get_current_position_failure": "Falla de ubicación. Asegúrese de tener habilitado el GPS y de que esté autorizado Ocean Plastic Tracker para acceder a su ubicación.",
    "location": "Ubicación",
    "name_pseudo": "Nombre o seudo",
    "next": "Siguiente",
    "no_results": "Ningún resultado",
    "optional": "opcional",
    "previous": "Anterior",
    "quantity": "Cantidad",
    "report_date": "Fecha de reporte",
    "report_review": "Gracias por su testimonio. Uno administrador revisado soon",
    "report": "Testimonio",
    "submit": "Enviar",
    "search_tracers": "Busca un rastreador. Ex: Bouchon, cartouche, ...",
    "click_map": "Haga clic o arrastre el marcador para geoetiquetar su testimonio.",
    "tracers": "Trazador | Trazadores",
    "submit_report_failure": "Error al enviar el informe",
    "photo": "Foto",
    "upload": "Upload",
    "photo_multiple_tracer": "Una foto puede contener varios marcadores",
    "load_tracers_failure": "Fallo al cargar los trazadores",
    "why_account": "Puede crear una cuenta para administrar sus informes y completar su nombre."
  }
}
</i18n>
