FROM node:lts-alpine
WORKDIR /zenn
ADD package.json /zenn/package.json
RUN npm install

EXPOSE 8000

ENTRYPOINT ["npx", "zenn"]
CMD ["preview"]
