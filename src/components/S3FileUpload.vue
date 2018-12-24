<template>
    <div>
        <b-progress v-if="loading" :value="progress" :max="files.length" show-progress height="2rem" class="mb-2"></b-progress>
        <b-form id="s3-file-uploader">
            <b-form-group
                        label="Files:"
                        label-for="file"
                        description="">
                <b-form-row>
                    <b-form-file ref="fileinput" v-model="files" placeholder="Choose files..." multiple :disabled="loading"></b-form-file>
                </b-form-row>
            </b-form-group>
            <b-button @click="upload" type="submit" variant="primary" :disabled="loading || files.length === 0">
                {{ getButtonLabel() }}
            </b-button>
        </b-form>
    </div>
</template>

<script>
export default {
    data() {
        return {
            files: [],
            progress: 0,
            loading: false,
            success: false,
        }
    },
    methods: {
        getButtonLabel() {
            if (this.loading) {
                return 'Uploading...';
            } else {
                return 'Upload';
            }
        },
        uploadSingleFile(file, uploadId) {
            const fileChunkSize = 100000000; // 100MB
            const fileSize = file.size;
            const numChunks = Math.round(fileSize / fileChunkSize) + 1;
            const promises = [];

            for (let i = 0; i < numChunks; i++) {
                const start = i * fileChunkSize
                const end = start + fileChunkSize
                const blob = (i + 1 < numChunks) ? file.slice(start, end) : file.slice(start);
                promises.push(
                    fetch(`${process.env.VUE_APP_BACKEND_URL}/get-multipart-url?fileName=${file.name}&part=${i + 1}&uploadId=${uploadId}`)
                        .then(response => response.json())
                        .then(data => fetch(data.url, {
                            method: 'PUT',
                            body: blob,
                        }))
                        .then(response => ({
                            ETag: response.headers.get('ETag'),
                            PartNumber: i + 1,
                        }))
                );
            }
            return Promise.all(promises);
        },
        async upload(event) {
            event.preventDefault();

            this.success = false;
            
            this.loading = true;
            this.progress = 0;
            const promises = [];
            for (let file of this.files) {
                const fileName = file.name;
                const data = await fetch(`${process.env.VUE_APP_BACKEND_URL}/init-upload?fileName=${fileName}`)
                    .then(response => response.json());

                const uploadId = data.uploadId;
                const response = await this.uploadSingleFile(file, data.uploadId);
                const promise = fetch(`${process.env.VUE_APP_BACKEND_URL}/complete-upload`, {
                    method: 'POST',
                    body: JSON.stringify({
                        fileName: fileName,
                        parts: response,
                        uploadId,
                    }),
                    headers: {
                        "Content-Type": "application/json",
                    },
                }).then(() => {
                    this.progress++;
                });
                promises.push(promise);
            }

            Promise.all(promises)
                .then(() => {
                    this.success = true;
                })
                .finally(() => {
                    this.loading = false;
                    this.files = [];
                    this.$refs.fileinput.reset();
                });
        }
    }
}
</script>
