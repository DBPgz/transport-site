<shortlist>
    <div class="shortlist" each={ item in shortlist }>
        <div class="shortlist-image">
            <img src={ item.logo }/>
        </div>
        <div class="shortlist-content">
            <div class="shortlist-description">
                <h1>{ item.title }</h1>
                <markdown content={ item.description }></markdown>
            </div>
            <div class="shortlist-details">
                <div>
                    <div>
                        <i class="fa fa-external-link" aria-hidden="true"></i>
                        <a href="https://www.data.gouv.fr/datasets/{ item.slug }/">
                            { parent.opts.seedatagouvfr }
                        </a>
                    </div>
                    <div class="download">
                        <i class="fa fa-download" aria-hidden="true"></i>
                        <a href="{ item.download_uri }">{ parent.opts.download }</a>
                    </div>
                </div>
                <div>
                    <div>
                        <span>{ parent.opts.territory }</span>
                        <span class="badge-notice">{ item.spatial }</span>
                    </div>
                    <div class="shortlist-details">
                        <div>
                            <span>{ parent.opts.licence } </span>
                            <span class="badge-notice">{ item.license } </span>
                        </div>
                        <div>
                            <span>Format</span>
                            <span class="badge-notice">GTFS</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script type="es6">
        this.shortlist = []

        this.fetch_shortlist = () => {
            let licences = {
                'odc-odbl': 'ODbL',
                'fr-lo': opts.frlo
            }

            fetch('/data/datasets.json',)
                .then(response => { return response.json() })
                .then(data => {
                    data = data.filter(l => l['anomalies'].length == 0)
                    data.forEach(l => l['license'] = licences[l['license']])
                    this.update(this.shortlist = data)
                 })
        }

        this.on('mount', this.fetch_shortlist)
    </script>
</shortlist>