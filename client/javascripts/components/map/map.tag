<map>
    <div class="map"></div>

    <script type="es6">
        import { addMap } from './map'

        this.render = () => addMap(this.root.firstChild, '/api/datasets/', this.opts)
        this.on('mount', this.render)
    </script>
</map>
