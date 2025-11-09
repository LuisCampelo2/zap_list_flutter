import sgMail from '@sendgrid/mail';

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const send = async ( msg ) => {
  try {
    await sgMail.send(msg);
    console.log('E-mail enviado');
  } catch (err) {
    console.error('Erro ao enviar e-mail:', err);
  }
}

const sendActivationEmail = (email, token) => {
  const href = `${process.env.FRONTEND_URL}/activate/${token}`
  const msg = {
    to: email,
    from: 'zaplistbusiness@gmail.com',
    subject: 'Ativação de conta',
    html: ` <!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Ativação de Conta</title>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
  <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; margin: auto; background-color: #ffffff; padding: 20px; border-radius: 8px;">
    <tr>
      <td align="center" style="padding-bottom: 20px;">
        <h2 style="color: #333333;">Bem-vindo ao Zap List!</h2>
      </td>
    </tr>
    <tr>
      <td style="color: #555555; font-size: 16px; line-height: 1.5;">
        <p>Obrigado por se cadastrar! Para começar a usar sua conta, clique no botão abaixo e ative seu cadastro:</p>
        <p style="text-align: center; margin: 30px 0;">
          <a href="${href}" style="background-color: #28a745; color: #ffffff; padding: 12px 20px; text-decoration: none; border-radius: 5px; display: inline-block;">Ativar Conta</a>
        </p>
        <p>Se você não criou essa conta, pode ignorar este email.</p>
        <p>Qualquer dúvida, estamos à disposição!</p>
        <p>Abraços,<br>Equipe Zap List!</p>
      </td>
    </tr>
    <tr>
      <td align="center" style="font-size: 12px; color: #999999; padding-top: 20px;">
        © 2025 Zap List. Todos os direitos reservados.
      </td>
    </tr>
  </table>
</body>
</html>`,
  };
  return send(msg);
}

const sendToken = (email, token) => {
  const msg = {
    to: email,
    from: 'zaplistbusiness@gmail.com',
    subject: 'Ativação de conta',
    html: `  <html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
      <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f7;
      margin: 0;
      padding: 20px;
    }

    .container {
      max-width: 600px;
      margin: auto;
      background: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }

    .card-header {
      background: rgb(255, 100, 10);
      color: #ffffff;
      padding: 16px;
      font-size: 20px;
      text-align: center;
      font-weight: bold;
    }

    .card-body {
      padding: 30px 20px;
      text-align: center;
      color: #555555;
    }

    .card-body h1 {
      margin: 12px 0;
      font-size: 18px;
      font-weight: normal;
    }

    .token {
      display: inline-block;
      font-size: 28px;
      font-weight: bold;
      color: #1a73e8;
      background: #f0f4ff;
      padding: 12px 24px;
      border-radius: 6px;
      letter-spacing: 6px;
      margin: 20px 0;
    }

    .card-footer {
      background: #f9f9f9;
      font-size: 12px;
      color: #999999;
      text-align: center;
      padding: 16px;
    }

    @media (max-width: 500px) {
      .card-body {
        padding: 20px 15px;
      }

      .token {
        font-size: 24px;
        padding: 10px 18px;
        letter-spacing: 4px;
      }
    }
  </style>
</head>

<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                Recuperação de senha
            </div>
            <div class="card-body">
                <h1>Seu token para trocar de senha</h1>
                <h1>${token}</h1>
            </div>
            <div class="card-footer">
                 © 2025 Zap List. Todos os direitos reservados.
            </div>
        </div>
    </div>
</body>
</html>`
  }

  return send(msg)
}

export const emailService = {
  sendActivationEmail,
  sendToken,
}