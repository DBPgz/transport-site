<validation>
    <h1>Validation</h1>
    <div class="validation__chooser">
        <a class="badge-notice" onclick={ init_errors }>{ this.opts.errors }</a>
        <a class="badge-notice" onclick={ init_warnings }>{ this.opts.warnings }</a>
        <a class="badge-notice" onclick={ init_notices }>{ this.opts.notices }</a>
    </div>
    <ul if={ this.page_count > 0}>
        <li class="validation__message" each="{ text, i in messages }">
            { text }
        </li>
    </ul>

    <span if={ this.page_count == 0 }> { this.empty_messages[this.to_display] } </span>

    <div class="validation__pagination">
        <button class="badge-notice" disabled={ page == 0 } onclick={ before }> < </button>
        <button class="badge-notice" disabled={ page == this.page_count - 1} onclick={ next }> > </button>
    </div>

    <script type="es6">
        this.on('before-mount', () => {
            this.validation = []
            this.to_display = 'warnings'
            this.page = 0
            this.page_count = 0
            this.page_size = 10
            this.messages = []
            this.empty_messages = {
                'errors': this.opts.no_errors,
                'warnings': this.opts.no_warnings,
                'notices': this.opts.no_notices}
        })

        this.on('mount', () => {
            let headers = new Headers()
            headers.append('Accept', 'application/vnd.api+json')
            fetch('/api/datasets/' + this.opts.slug + '/validations/',
                {headers: headers}
            ).then((response) => {
                return response.json()
            }).then((data) => {
                this.validation = data
                this.init_warnings()
                this.update()
            })
        })

        this.init_errors = () => {
            this.init_messages('errors')
        }
        this.init_warnings = () => {
            this.init_messages('warnings')
        }
        this.init_notices = () => {
            this.init_messages('notices')
        }

        this.init_messages = (_type) => {
            this.to_display = _type
            this.page = 0
            this.show_messages()
        }

        this.show_messages = () => {
            this.messages = this.validation[this.to_display]
            this.page_count = Math.floor(this.messages.length / this.page_size)
            this.messages = this.messages.slice(this.page * this.page_size,
                (this.page + 1) * this.page_size)
            this.update()
        }

        this.next = () => {
            this.page = this.page + 1
            this.show_messages()
        }

        this.before = () => {
            this.page = this.page - 1
            this.show_messages()
}
    </script>

</validation>
