# animabackend
Back end do formulário do instituto anima

Para rodar na vercel:

No package.json, em scripts adicionar:
```node
"postinstall": "prisma generate"
```

Adicionar o arquivo vercel.json na raiz do projeto com o seguinte conteúdo:

```node
{
    "version": 2,
    "builds": [
        {
            "src": "src/index.ts",
            "use": "@vercel/node"
        }
    ],
    "routes": [
        {
            "src": "(.*)",
            "dest": "src/index.ts"
        }
    ]
}
```
