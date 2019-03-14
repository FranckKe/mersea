<template>
  <div class="add-report-layer">
    <section id="addReport" class="add-report" :class="{ hidden: !isFormActive }">
      <h2 class="title is-2">{{ $t('add_report') }}</h2>
      <a @click="closeAddReportForm" class="button is-danger close-button">
        <font-awesome-icon icon="times"/>
      </a>
      <div class="steps" id="addReportSteps">
        <div class="step-item is-active is-success">
          <div class="step-marker">1</div>
          <div class="step-details">
            <p class="step-title">{{ $t('location') }}</p>
          </div>
        </div>
        <div class="step-item is-active">
          <div class="step-marker">2</div>
          <div class="step-details">
            <p class="step-title">{{ $t('report') }}</p>
          </div>
        </div>
        <div class="step-item">
          <div class="step-marker">3</div>
          <div class="step-details">
            <p class="step-title">{{ $tc('tracers', '1') }}</p>
          </div>
        </div>
        <div class="step-item">
          <div class="step-marker">4</div>
          <div class="step-details">
            <p class="step-title">{{ 'Saving' }}</p>
          </div>
        </div>
        <form class="add-report-form" @submit.prevent="submitReports">
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
                <b-input
                  v-model="coordinates"
                  type="text"
                  name="coordinates"
                  v-validate="'required'"
                ></b-input>
              </b-field>
              <p>{{ $t('click_to_report') }}</p>
              <b-field
                :label="$t('address')"
                :type="errors.has('address') ? 'is-danger' : ''"
                :message="errors.has('address') ? errors.first('address') : ''"
              >
                <b-input
                  v-model="address"
                  type="text"
                  name="address"
                  :data-vv-as="$t('address') | lowercase"
                  v-validate="'required'"
                  disabled="true"
                ></b-input>
              </b-field>
            </div>
            <div class="step-content">
              <b-field
                :label="$t('name_pseudo')"
                :type="errors.has('username') ? 'is-danger' : ''"
                :message="
                  errors.has('username') ? errors.first('username') : ''
                "
              >
                <b-input
                  v-model="username"
                  name="username"
                  :data-vv-as="$t('name_pseudo') | lowercase"
                  v-validate="'required'"
                  :disabled="this.$auth.check()"
                ></b-input>
              </b-field>
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
                  :mobile-native="false"
                  :data-vv-as="$t('report_date') | lowercase"
                  v-validate="'required'"
                ></b-datepicker>
              </b-field>
              <b-field
                class="file"
                :type="errors.has('files') ? 'is-danger' : ''"
                :message="errors.has('files') ? errors.first('files') : ''"
                v-if="this.$auth.user() && !this.$auth.user().senior"
              >
                <b-upload
                  v-model="files"
                  name="files"
                  :data-vv-as="$t('photo') | lowercase"
                  v-validate="
                    'required|size:4000|ext:jpg,JPG,jpeg,JPEG,png,PNG,tiff,TIFF,webp,WEBP'
                  "
                >
                  <a class="button is-primary">
                    <b-icon icon="upload"></b-icon>
                    <span>{{ $t('photo') }}</span>
                  </a>
                </b-upload>
                <span class="file-name" v-if="files && files.length">{{ files[0].name }}</span>
              </b-field>
              <b-field
                :label="`${$t('description')} (${$t('optional')})`"
                :type="errors.has('description') ? 'is-danger' : ''"
                :message="
                  errors.has('description') ? errors.first('description') : ''
                "
              >
                <b-input
                  v-model="description"
                  name="description"
                  maxlength="300"
                  type="textarea"
                  :data-vv-as="$t('description') | lowercase"
                  v-validate="'max:300'"
                ></b-input>
              </b-field>
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
                    v-for="(addReportValidationError, index) in addReportsValidationErrors[index]"
                    :key="index"
                  >- {{ addReportValidationError.metadata.reason }}</li>
                </ul>
              </b-message>
              <div v-for="(tracer, index) in selectedTracers" :key="index">
                <b-field key="key" grouped>
                  <b-field :label="index === 0 ? '-' : ''" custom-class="remove-tracer-input-label">
                    <a
                      @click="removeTracerInput(index)"
                      class="button is-outlined"
                      :disabled="selectedTracers.length == 1"
                    >
                      <b-icon icon="times"/>
                    </a>
                  </b-field>
                  <b-field
                    :label="index === 0 ? $tc('tracers', 1) : ''"
                    :type="errors.has('tracer') ? 'is-danger' : ''"
                    :message="
                      errors.has('tracer') ? errors.first('tracer') : ''
                    "
                  >
                    <b-autocomplete
                      v-model="tracerNames[index]"
                      name="tracer"
                      :data="tracers"
                      field="name"
                      :open-on-focus="true"
                      @select="option => (selectedTracers[index] = option)"
                      :data-vv-as="$tc('tracers', 1) | lowercase"
                      v-validate="'required'"
                    >
                      <template slot-scope="props">
                        <div class="media">
                          <div class="media-left">
                            <img class="image is-64x64" :src="`${apiUrl}${props.option.photo}`">
                          </div>
                          <div class="media-content">
                            {{ props.option.name }}
                            <br>
                            <small>{{ props.option.type }}</small>
                          </div>
                        </div>
                      </template>
                      <template slot="empty">{{ $t('no_results') }}</template>
                    </b-autocomplete>
                  </b-field>
                  <b-field
                    :label="index === 0 ? $t('quantity') : ''"
                    :type="errors.has('quantity') ? 'is-danger' : ''"
                    :message="
                      errors.has('quantity') ? errors.first('quantity') : ''
                    "
                    expanded
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
                  <b-field :label="index === 0 ? '-' : ''" customClass="remove-tracer-input-label">
                    <span
                      @click="getSubmissionStatus(index) == 'failed' && submitReport(index)"
                      :class="{
                        'report-submission-status': true,
                        'has-text-success': getSubmissionStatus(index) == 'saved',
                        'has-text-danger': getSubmissionStatus(index) == 'failed',
                      }"
                      :disabled="!(getSubmissionStatus(index) == 'failed')"
                    >
                      <b-icon
                        :icon="getSubmissionStatusIcon(index)"
                        :custom-class="getSubmissionStatus(index) == 'submitting' ? 'fa-spin' : ''"
                      />
                    </span>
                  </b-field>
                </b-field>
              </div>
              <b-field style="text-align: center;">
                <a
                  class="button is-primary add-tracer-input"
                  @click="addTracerInput"
                  :disabled="selectedTracers.length >= 8"
                >
                  <b-icon icon="plus"></b-icon>
                </a>
              </b-field>
            </div>
            <div class="step-content">
              <p>{{ $t('report_review') }}</p>
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
            >{{ $t('previous') }}</a>
          </div>
          <div class="steps-action">
            <button
              href="#"
              id="nextAction"
              data-nav="next"
              class="button"
              :class="{
                'is-success': currentStep === 2,
                hidden: currentStep === 3,
                'is-loading': currentStep === 2 && this.areSomeReportsSubmitting
              }"
            >{{ currentStep === 2 && !this.areAllReportsSubmitted ? $t('submit') : $t('next') }}</button>
            <a
              href="#"
              class="button is-danger close-button-step"
              :class="{ hidden: currentStep !== 3 }"
              @click="closeAddReportForm"
            >{{ $t('close') }}</a>
          </div>
        </div>
      </div>
    </section>
    <a
      href="#"
      @click="
        e => {
          isFormActive = true
        }
      "
      class="add-report-button button is-success"
      :class="{ hidden: isFormActive }"
    >{{ $t('add_report') }}</a>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const addReportModule = createNamespacedHelpers('addReport')
const tracersModule = createNamespacedHelpers('tracers')

import bulmaSteps from 'bulma-steps'
import moment from 'moment'

export default {
  name: 'add-report',
  data() {
    return {
      apiUrl: this.$apiUrl,
      tracers: [],
      selectedTracers: [{}],
      areSubmitting: [false],
      areSubmitted: [false],
      files: [],
      isSaved: [false],
      quantities: [1],
      tracerNames: [''],
      username: this.$auth.check() ? this.$auth.user().name : '',
      description: '',
      reportDate: new Date(),
      addReportsErrors: [],
      addReportsValidationErrors: [],
      bulmaSteps: {}
    }
  },
  async mounted() {
    try {
      await this.loadTracers()
      if (this.$auth.check()) this.username = this.$auth.user().name
    } catch (error) {
      this.$toast.open({
        message: this.$t('load_tracers_failure'),
        duration: 5000,
        type: 'is-danger'
      })
    }

    this.tracers = this.getTracersData()
    this.bulmaSteps = new bulmaSteps(
      document.getElementById('addReportSteps'),
      {
        beforeNext: step => {
          return new Promise(async (resolve, reject) => {
            if (step === 0) {
              this.username = this.$auth.check() ? this.$auth.user().name : ''
              resolve(
                this.$validator.validate('coordinates') &&
                  this.$validator.validate('address')
              )
            }
            if (step === 1) {
              let validateFiles = true

              // The 'files' field does not always exist
              // and vee-validate complains when it does not
              if (
                !this.$auth.check() ||
                (this.$auth.user() && !this.$auth.user().senior)
              ) {
                validateFiles = this.$validator.validate('files')
              }

              resolve(
                this.$validator.validate('username') &&
                  this.$validator.validate('reportDate') &&
                  this.$validator.validate('description') &&
                  validateFiles
              )
            }
            if (step === 2) {
              let validateForm = await this.$validator.validateAll()
              if (this.areAllReportsSubmitted) {
                resolve(true)
              } else if (validateForm) {
                try {
                  await this.submitReports()
                  resolve(false)
                } catch (err) {
                  console.warn(err)
                  reject(false)
                }
              } else {
                console.warn(this.$validator.errors)
                console.warn(this.$validator.fields)
                reject(false)
              }
            }

            resolve(true)
          })
        },
        onShow: step => {
          return new Promise(async (resolve, reject) => {
            const oldStep = this.currentStep

            this.currentStep = step

            if (step === 3) {
              this.address = ''
              this.coordinates = ''
              this.description = ''
              this.files = []
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
            }

            resolve()
          })
        }
      }
    )
  },
  methods: {
    ...addReportModule.mapMutations([
      'setIsFormActive',
      'setCoordinates',
      'setAddress',
      'setCurrentStep'
    ]),
    ...addReportModule.mapGetters([
      'getIsFormActive',
      'getCoordinates',
      'getAddress',
      'getCurrentStep'
    ]),
    ...tracersModule.mapGetters({
      getTracersData: 'getData'
    }),
    ...tracersModule.mapActions(['loadTracers']),
    submitReports() {
      return new Promise(async (resolve, reject) => {
        this.addReportsErrors = []
        this.addReportsValidationErrors = []

        const promises = []
        for (let index = 0; index < this.selectedTracers.length; index++) {
          const promise = this.submitReport(index)
          promises.push(promise)
        }

        try {
          await Promise.all(promises)

          resolve()
        } catch (e) {
          reject(e)
        }
      })
    },
    submitReport(index) {
      this.areSubmitting.splice(index, 1, true)
      this.areSubmitted.splice(index, 1, false)

      return this.submitReportPromise(index)
        .then(() => {
          this.isSaved.splice(index, 1, true)
          delete this.addReportsErrors[index]
          delete this.addReportsValidationErrors[index]
        })
        .catch(error => {
          if ((((error || {}).response || {}).data || {}).errors != null)
            this.addReportsValidationErrors.splice(
              index,
              1,
              error.response.data.errors
            )
          this.addReportsErrors.splice(
            index,
            1,
            this.$t('submit_report_failure')
          )
          this.isSaved.splice(index, 1, false)
        })
        .finally(() => {
          this.areSubmitting.splice(index, 1, false)
          this.areSubmitted.splice(index, 1, true)
        })
    },
    submitReportPromise(index) {
      return new Promise(async (resolve, reject) => {
        try {
          let file64 =
            this.files.length > 0 ? await this.getBase64(this.files[0]) : ''

          const postDataJson = {
            name: this.$auth.check() ? this.$auth.user().name : this.username,
            address: this.address,
            latitude: this.coordinates.split(',')[0],
            longitude: this.coordinates.split(',')[1],
            reported_at: String(moment(this.reportDate).format('YYYY-MM-DD')),
            tracer_id: this.selectedTracers[index].id,
            quantity: this.quantities[index],
            description: this.description
          }
          if (file64.length > 0) postDataJson.photo = file64

          await this.$http({
            method: 'POST',
            url: `/reports`,
            data: postDataJson
          })

          resolve(index)
        } catch (error) {
          reject(error, index)

          throw error
        }
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
      this.isFormActive = false
      const currentStep = this.bulmaSteps.get_current_step_id()
      if (currentStep === 3) {
        for (let i = 0; i < currentStep; i++) {
          this.bulmaSteps.previous_step()
        }
      }
    },
    removeTracerInput(index) {
      this.selectedTracers.splice(index, 1)
      this.quantities.splice(index, 1)
      this.tracerNames.splice(index, 1)
    },
    addTracerInput() {
      if (this.selectedTracers.length >= 8) {
        return
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
    }
  },
  computed: {
    ...addReportModule.mapState({
      isFormActive: state => state.isFormActive
    }),
    isFormActive: {
      set(value) {
        this.setIsFormActive(value)
      },
      get() {
        return this.getIsFormActive()
      }
    },
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
    areAllReportsSubmitted: {
      set(areAllReportsSubmitted) {
        this.areAllReportsSubmitted = areAllReportsSubmitted
      },
      get() {
        return this.areSubmitted.every(isSubmitting => isSubmitting)
      }
    },
    areSomeReportsSubmitting: {
      set(areAllReportsSubmitting) {
        this.areAllReportsSubmitting = areAllReportsSubmitting
      },
      get() {
        return this.areSubmitting.some(isSubmitting => isSubmitting)
      }
    }
  }
}
</script>

<style scoped>
.add-report {
  background-color: white;
  display: flex;
  height: calc(100vh - 145px);
  width: 95%;
  max-width: 500px;
  position: absolute;
  z-index: 5;
  border-radius: 3px;
  top: 115px;
  left: 10px;
  padding: 15px;
  flex-direction: column;
  overflow-y: scroll;
  overflow-x: hidden;
  min-height: auto;
  margin-top: 0;
}

@media only screen and (max-device-width: 1024px) {
  .add-report {
    height: auto;
    min-height: calc(60vh - 115px);
    width: 100%;
    max-width: 100%;
    left: 0;
    margin-top: 40vh;
    padding: 30px;
  }
}

@media only screen and (max-device-width: 768px) {
  .add-report {
    padding: 30px 10px 10px 10px;
  }
}

.add-report-form >>> .remove-tracer-input-label {
  color: white;
}

.add-report::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

.add-report::-webkit-scrollbar-track {
  background-color: var(--color-primary-light);
  border-radius: 0px;
}

.add-report::-webkit-scrollbar-thumb {
  background-color: var(--color-primary);
  border-radius: 0px;
}

.add-tracer-input {
  margin-top: 20px;
}

.report-submission-status > .icon {
  height: 36px;
}

.close-icon {
  align-self: flex-end;
}

.add-report-form {
  flex-basis: 100%;
  display: flex;
  flex-direction: column;
}

.add-report .field.file .help {
  flex-basis: 100%;
}

.add-report .field.file {
  flex-wrap: wrap;
}

.add-report-layer .add-report-button {
  position: absolute;
  bottom: 33px;
  right: 65px;
}

.hidden {
  display: none !important;
}

.add-report .steps {
  flex-grow: 1;
}

.submit-form-error ul li {
  margin-left: 15px;
}

.add-report .close-button {
  width: 35px;
  position: absolute;
  right: 0px;
  top: 10px;
}
</style>

<i18n>
{
  "en": {
    "add_report": "Add a report",
    "address": "Address",
    "cancel_report": "Close reporting",
    "click_select": "Click to select",
    "click_to_report": "Click on the map to locate the report",
    "close": "Close",
    "description": "Description",
    "done": "Done",
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
    "tracers": "Tracer | Tracers",
    "submit_report_failure": "Fail to submit report",
    "photo": "Photo",
    "load_tracers_failure": "Fail to load tracers"
  },
  "fr": {
    "add_report": "Ajouter un témoignage",
    "address": "Adresse",
    "cancel_report": "Fermer l'ajout de témoignage",
    "click_select": "Cliquez pour sélectionner",
    "click_to_report": "Cliquer sur la carte pour localiser le témoignage",
    "close": "Fermer",
    "description": "Description",
    "done": "Fin",
    "location": "Localisation",
    "name_pseudo": "Nom ou pseudo",
    "next": "Suivant",
    "no_results": "Aucun résultats",
    "optional": "optionnel",
    "previous": "Précédent",
    "quantity": "Quantité",
    "report_date": "Date de témoignage",
    "report_review": "Merci pour votre témoignage. Un administrateur va bientôt le passer en revu.",
    "report": "Témoignage",
    "submit": "Soumettre",
    "tracers": "Tracer | Tracers",
    "submit_report_failure": "Échec d'ajout d'un témoignage",
    "photo": "Photo",
    "load_tracers_failure": "Échec de chargement des tracers"
  },
  "es": {
    "add_report": "Agrega un testimonio",
    "address": "Dirección",
    "cancel_report": "Cerrar agrega testimonio",
    "click_select": "Clic para seleccionar",
    "click_to_report": "Clic sobre el mapa para localizar el testimonio",
    "close": "Cerrar",
    "description": "Descripción",
    "done": "Final",
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
    "tracers": "Trazadore | Trazadores",
    "submit_report_failure": "Error al enviar el informe",
    "photo": "Foto",
    "load_tracers_failure": "Fail to load tracers"
  }
}
</i18n>
