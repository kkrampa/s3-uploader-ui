prod-env-build:
	NODE_ENV=production yarn build

prod-env-deploy:
	aws s3 sync dist/ s3://s3-uploader-ui
