const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');
const express = require('express');
const cors = require('cors');

// Init
admin.initializeApp();
sgMail.setApiKey(functions.config().sendgrid.api_key);

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// Send OTP
app.post('/sendEmailOTP', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Email is required' });

    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    const now = Date.now();
    await admin.firestore().collection('otps').doc(email).set({
      otp,
      email,
      createdAt: admin.firestore.Timestamp.fromMillis(now),
      expiresAt: admin.firestore.Timestamp.fromMillis(now + 10 * 60 * 1000),
      verified: false,
      attempts: 0
    });

    const msg = {
      to: email,
      from: {
        email: functions.config().sendgrid.from_email,
        name: 'Cash Lander'
      },
      subject: 'Your Cash Lander OTP Code',
      html: `<h2>Your Code: ${otp}</h2><p>Expires in 10 minutes.</p>`,
      text: `Your code is ${otp}`
    };

    await sgMail.send(msg);
    return res.status(200).json({ success: true, message: 'OTP sent' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
});

// Verify OTP
app.post('/verifyEmailOTP', async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) return res.status(400).json({ error: 'Email and OTP required' });

    const ref = admin.firestore().collection('otps').doc(email);
    const doc = await ref.get();
    if (!doc.exists) return res.status(404).json({ error: 'No OTP found' });

    const data = doc.data();
    if (data.verified) return res.status(400).json({ error: 'OTP already used' });
    if (Date.now() > data.expiresAt.toMillis()) {
      await ref.delete();
      return res.status(400).json({ error: 'OTP expired' });
    }
    if (data.otp !== otp) return res.status(400).json({ error: 'Invalid OTP' });

    await ref.update({
      verified: true,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    return res.status(200).json({ success: true, message: 'OTP verified' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
});

// Export HTTP function
exports.api = functions.https.onRequest(app);
