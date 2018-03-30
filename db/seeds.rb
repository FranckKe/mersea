Page.create!(
  name: 'Le projet',
  language: 'fr',
  content: <<~ABOUT
    <div class="page-container">
        <h1>Description du projet</h1>
        <h2>Les impacts de la pollution plastique</h2>
        <p>8 millions de tonnes de plastiques sont déversés dans les océans chaque année. Dommages sur les habitants, perturbateurs
            endocriniens, blessures, décès d’animaux marins par ingestion ou étranglement, ces pollutions massives entraînent
            des pertes économiques majeures (baisse du tourisme, impacts sur les pêches…).</p>
         <p>80% des déchets retrouvés sur le littoral proviennent du continent par les rivières, les eaux pluviales. Le reste provient
            du trafic maritime et des activités en mer. On estime à 10 000 le nombre de conteneurs perdus en mer par an au niveau
            mondial.
        </p>
         <p>Pertes économiques (baisse tourisme), dommages sur les habitats marins, blessures ou décès d’animaux marins par ingestion
            ou étranglement. Des problèmes pour la navigation, déplacement d'espèces marines qui s'accroche aux déchets (<a href="https://marinedebris.noaa.gov/discover-issue/impacts" target="_blank">www.marinedebris.noaa.gov</a>).</p>
         <h2>Le rôle des traceurs</h2>
         <p>Parmi les pollutions plastiques, certains déchets racontent une histoire et permettent de suivre leur propagation au
            gré des courants et des tempêtes. Ces traceurs permettent de qualifier et de quantifier une pollution provenant soit
            de conteneurs perdus en mer soit de déversements accidentels en milieu naturel. Avec plus de 150 navires qui passent
            tous les jours dans le rail d’Ouessant, la zone Atlantique est un observatoire unique de ces traceurs.
        </p>
         <h2>Technologie</h2>
        <p>Le code est publié sous licence Open Source MIT sur GitHub : <a href="https://github.com/FranckKe/mersea" target="_blank">Mersea</a></p>
        <p>Les contributeurs au code : Pierre Charpentier / Marc Douchement
            / Franck Kerbiriou</p>
    </div>
  ABOUT
)

Page.create!(
  name: 'ANSEL',
  language: 'fr',
  content: <<~ANSEL
    <div class="page-container">
        <h1>ANSEL &amp; co</h1>
        <p>L’association ANSEL sensibilise aux échouages de déchets sur le littoral depuis 17 ans. Après avoir lancé le Réseau d’Observation
            d'Échouages de Déchets en Atlantique en 2014, le besoin d’une cartographie devient évident pour suivre les nombreuses
            observations collectées. Les premières réflexions avec le fonds Explore de Roland Jourdain sur ce projet de carto
            se concrétise lors du Ocean Hackathon de Brest en octobre 2016. A cette occasion Pierre Charpentier, Franck Kerbiriou,
            Marc Douchement et Caroline Geisert développent en 48h la première version de la cartographie.
        </p>
         <h2>Contacts</h2>
        <p>Ansel asso 29900 Concarneau</p>
        <p>Réseau d’observation d’échouage de déchets en atlantique, Facebook.</p>
    </div>
  ANSEL
)

Page.create!(
  name: 'Mentions légales',
  language: 'fr',
  content: <<~DISCLAIMER
    <div class="page-container">
        <h2>Mentions légales</h2>
        <p>L’association ANSEL est producteur de la base de donnée issue des observations. Les données que vous communiquez seront
            exploitées exclusivement dans le cadre des objectif de ce projet. Les photos communiquées sont sous la responsabilité
            du producteur et sont temporairement stockées pour la validation des relevés. En communiquant la photographie pour
            la réalisation de ce projet, le producteur cède les droits d’utilisation au profit de la plateforme.</p>
        <p>Conformément à la loi "informatique et libertés" du 6 janvier 1978 modifiée, vous bénéficiez d’un droit d’accès et de
            rectification aux informations qui vous concernent. Si vous souhaitez exercer ce droit et obtenir communication des
            informations vous concernant, veuillez vous adresser à l’association ANSEL.
        </p>
    </div>
  DISCLAIMER
)

Page.create!(
  name: 'Liens',
  language: 'fr',
  content: <<~LINKS
    <div class="page-container">
        <h1>Liens utiles</h1>
        <ul>
            <li>Mammifères et oiseaux échoués <a href="http://crmm.univ-lr.fr/index.php/fr/reseau-national-echouages" target="_blank">Réseau Pélagis</a></li>
            <li>Méduses échouées <a href="http://www.mer-littoral.org/formulaire-meduses.php" target="_blank">Réseau “Mer et Littoral”</a></li>
            <li>Bloom planctonique <a href="http://www.phenomer.org/" target="_blank">Phenomer</a></li>
            <li>Hydrocarbures et explosifs : appeler les pompiers</li>
        </ul>
    </div>
  LINKS
)

Page.create!(
  name: 'Sécurité',
  language: 'fr',
  content: <<~SECURITY
    <div class="page-container">
        <h1>Sécurité</h1>
        <h2>Préservez la nature !</h2>
        <p>Faire attention à la laisse de mer, aux zones protégées pendant vos ramassages.</p>
        <h2>Protégez-vous !</h2>
        <p>Porter des gants, ne pas vider les contenants de leurs contenu (on ne sait pas ce qu’il y a dedans).</p>
        <h2>Explosifs et Hydrocarbures !</h2>
        <p>Ne surtout pas manipuler l’engin suspect et/ou explosif. Éventuellement mettre en place un système de protection afin que le public ne puisse toucher l’engin. Prévenir le 17 en précisant la taille de l’objet et le lieu exact de la découverte.</p>
        <p>Si vous découvrez des fûts ou des bidons, prévenir les pompiers (18).</p>
        <h2>Attention aux marées !</h2>
        <p>Ce serait dommage de se faire attraper par la marée et de devenir un traceur !</p>
    </div>
  SECURITY
)
