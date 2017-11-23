FROM alpine:3.5

# Update
RUN apk add --update nodejs git

RUN npm install --save http github-webhook-handler simple-git
ADD server.js server.js
EXPOSE 7777

ENTRYPOINT ["node", "server.js"]
