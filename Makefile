BUCKET_NAME ?= s3-uploader-ui

prod-env-build:
	NODE_ENV=production yarn build

prod-env-deploy:
	aws s3 sync dist/ s3://${BUCKET_NAME} --acl public-read
