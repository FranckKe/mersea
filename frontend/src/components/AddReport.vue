<template>
  <div class="add-report-layer">
    <section id="addReport" class="add-report" :class="{ hidden: !isFormActive }">
      <b-loading :is-full-page="false" :active.sync="isSubmitting" :can-cancel="false"></b-loading>

      <h2 class="title is-2 has-text-centered">{{ $t('add_report') }}</h2>
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
            <p class="step-title">{{ $tc('tracers', '1') }}</p>
          </div>
        </div>
        <div class="step-item">
          <div class="step-marker">3</div>
          <div class="step-details">
            <p class="step-title">{{ $t('report') }}</p>
          </div>
        </div>
        <div class="step-item">
          <div class="step-marker">4</div>
          <div class="step-details">
            <p class="step-title">{{ $t('done') }}</p>
          </div>
        </div>
        <form class="add-report-form" @submit.prevent="submitReport">
          <div class="steps-content">
            <div class="step-content">
              <b-field
                label="coordinates"
                class="hidden"
                :type="errors.has('coordinates') ? 'is-danger': ''"
                :message="errors.has('coordinates') ? errors.first('coordinates') : ''"
              >
                <b-input
                  v-model="coordinates"
                  type="text"
                  name="coordinates"
                  v-validate="'required'"
                ></b-input>
              </b-field>
              <b-field
                :label="$t('click_to_report')"
                :type="errors.has('address') ? 'is-danger': ''"
                :message="errors.has('address') ? errors.first('address') : ''"
              >
                <b-input v-model="address" type="text" name="address" v-validate="'required'"></b-input>
              </b-field>
            </div>
            <div class="step-content">
              <b-field
                :label="$tc('tracers', 1)"
                :type="errors.has('tracer') ? 'is-danger': ''"
                :message="errors.has('tracer') ? errors.first('tracer') : ''"
              >
                <b-autocomplete
                  v-model="tracerName"
                  name="tracer"
                  :data="data"
                  field="name"
                  :open-on-focus="true"
                  @select="option => selectedTracer = option"
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
                :label="$t('quantity')"
                :type="errors.has('quantity') ? 'is-danger': ''"
                :message="errors.has('quantity') ? errors.first('quantity') : ''"
              >
                <b-input
                  v-model="quantity"
                  name="quantity"
                  type="number"
                  step="1"
                  v-validate="'required|min_value:0'"
                ></b-input>
              </b-field>
            </div>
            <div class="step-content">
              <b-field
                :label="$t('name_pseudo')"
                :type="errors.has('username') ? 'is-danger': ''"
                :message="errors.has('username') ? errors.first('username') : ''"
              >
                <b-input v-model="username" name="username" v-validate="'required'"></b-input>
              </b-field>
              <b-field
                :label="$t('report_date')"
                :type="errors.has('reportDate') ? 'is-danger': ''"
                :message="errors.has('reportDate') ? errors.first('reportDate') : ''"
              >
                <b-datepicker
                  v-model="reportDate"
                  name="reportDate"
                  placeholder="$t('click_select')"
                  :mobile-native="false"
                  v-validate="'required'"
                ></b-datepicker>
              </b-field>
              <b-field
                class="file"
                :type="errors.has('files') ? 'is-danger': ''"
                :message="errors.has('files') ? errors.first('files') : ''"
              >
                <b-upload
                  v-model="files"
                  name="files"
                  v-validate="'required|size:4000|ext:jpg,JPG,jpeg,JPEG,png,PNG,tiff,TIFF,webp,WEBP'"
                >
                  <a class="button is-primary">
                    <b-icon icon="upload"></b-icon>
                    <span>Photo</span>
                  </a>
                </b-upload>
                <span class="file-name" v-if="files && files.length">{{ files[0].name }}</span>
              </b-field>
              <b-field
                :label="`${$t('description')} (${$t('optional')})`"
                :type="errors.has('description') ? 'is-danger': ''"
                :message="errors.has('description') ? errors.first('description') : ''"
              >
                <b-input
                  v-model="description"
                  name="description"
                  maxlength="300"
                  type="textarea"
                  v-validate="'max:300'"
                ></b-input>
              </b-field>
              <b-notification type="is-danger" v-if="addReportErrors.length > 0">
                <p
                  v-for="addReportError in addReportErrors"
                  :key="addReportError.metadata.id"
                >{{ addReportError.metadata.reason }}</p>
              </b-notification>
              <button type="submit" class="button is-success hidden">{{ $t('submit') }}</button>
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
            <a
              href="#"
              id="nextAction"
              data-nav="next"
              class="button"
              :class="{ 'is-success': currentStep === 2 }"
            >{{ currentStep === 2 ? $t('submit') : $t('next') }}</a>
          </div>
        </div>
      </div>
    </section>
    <a
      href="#"
      @click="e => { isFormActive = !isFormActive }"
      class="add-report-button button is-success"
      :class="[isFormActive ? 'is-danger' : 'is-success']"
    >{{ isFormActive ? $t('cancel_report') : $t('add_report') }}</a>
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
      data: this.getTracersData(),
      selectedTracer: null,
      isSubmitting: false,
      files: [],
      quantity: 1,
      tracerName: '',
      username: '',
      description: '',
      reportDate: new Date(),
      addReportErrors: []
    }
  },
  mounted() {
    new bulmaSteps(document.getElementById('addReportSteps'), {
      beforeNext: step => {
        return new Promise(async (resolve, reject) => {
          if (step === 0) {
            resolve(
              this.$validator.validate('coordinates') &&
                this.$validator.validate('address')
            )
          }
          if (step === 1) {
            resolve(this.$validator.validate('tracer'))
          }
          if (step === 2) {
            let validateForm = await this.$validator.validateAll()
            if (validateForm) {
              try {
                await this.submitReport()
                resolve(true)
              } catch (error) {
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
        this.currentStep = step
      }
    })
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
    submitReport() {
      this.addReportErrors = []
      this.isSubmitting = true
      return new Promise(async (resolve, reject) => {
        try {
          let file64 = await this.getBase64(this.files[0])

          const postDataJson = {
            name: this.username,
            address: this.address,
            latitude: this.coordinates.split(',')[0],
            longitude: this.coordinates.split(',')[1],
            reported_at: String(moment(this.reportDate).format('YYYY-MM-DD')),
            tracer_id: this.selectedTracer.id,
            quantity: this.quantity,
            photo: file64,
            description: this.description
          }

          await this.$http({
            method: 'POST',
            url: `/reports`,
            data: postDataJson
          })

          this.address = ''
          this.coordinates = ''
          this.description = ''
          this.files = []
          this.isSubmitting = false
          this.photo = ''
          this.quantity = 1
          this.reportDate = new Date()
          this.selectedTracer = null
          this.tracerName = ''
          this.username = ''

          resolve()
        } catch (error) {
          this.isSubmitting = false
          this.addReportErrors = error.response.data.errors
          reject(error)
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
    filteredDataObj() {
      return this.data.filter(
        option =>
          option.name
            .toString()
            .toLowerCase()
            .indexOf(this.tracerName.toLowerCase()) >= 0
      )
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

  .add-report-layer .add-report-button {
    position: absolute;
    top: 45vh;
  }
}

@media only screen and (max-device-width: 768px) {
  .add-report {
    padding: 30px 10px 10px 10px;
  }
  .add-report-layer .add-report-button {
    position: absolute;
    top: 43.5vh;
  }
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
</style>

<i18n>
{
  "en": {
    "add_report": "Add a report",
    "cancel_report": "Close reporting",
    "click_select": "Click to select",
    "click_to_report": "Click on the map to locate the report",
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
    "tracers": "Tracer | Tracers"
  },
  "fr": {
    "add_report": "Ajouter un témoignage",
    "cancel_report": "Fermer l'ajout de témoignage",
    "click_select": "Cliquez pour sélectionner",
    "click_to_report": "Cliquer sur la carte pour localiser le témoignage",
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
    "tracers": "Tracer | Tracers"
  },
  "es": {
    "add_report": "Agrega un testimonio",
    "cancel_report": "Cerrar agrega testimonio",
    "click_select": "Clic para seleccionar",
    "click_to_report": "Clic sobre el mapa para localizar el testimonio",
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
    "tracers": "Trazadore | Trazadores"
  }
}
</i18n>
