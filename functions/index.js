const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();
const db = admin.firestore();

const SENDGRID_API_KEY = functions.config().sendgrid.key;
sgMail.setApiKey(SENDGRID_API_KEY);

// 6 haneli rastgele kod üret
function generateCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// ✅ KOD GÖNDER FONKSİYONU
exports.sendVerificationCode = functions.https.onCall(async (data, context) => {
  const email = data.email;
  if (!email) {
    throw new functions.https.HttpsError("invalid-argument", "E-posta gerekli.");
  }

  const code = generateCode();
  const expireAt = Date.now() + 5 * 60 * 1000; // 5 dakika

  // Firestore’a yaz
  await db.collection("emailVerifications").doc(email).set({ code, expireAt });

  const msg = {
    to: email,
    from: "muhammedberat@ogrenci.beykoz.edu.tr", // SendGrid'de verified bir adres
    subject: "Yorgan Doğrulama Kodu",
    html: `<p><strong>${code}</strong> doğrulama kodun. 5 dakika içinde kullanmalısın.</p>`
  };

  try {
    await sgMail.send(msg);
    return { success: true };
  } catch (error) {
    console.error("Mail gönderilemedi:", error);
    throw new functions.https.HttpsError("internal", "Mail gönderilemedi.");
  }
});

// ✅ KOD DOĞRULAMA FONKSİYONU
exports.verifyCode = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const code = data.code;

  if (!email || !code) {
    throw new functions.https.HttpsError("invalid-argument", "E-posta ve kod gereklidir.");
  }

  const doc = await db.collection("emailVerifications").doc(email).get();

  if (!doc.exists) {
    throw new functions.https.HttpsError("not-found", "Kod bulunamadı.");
  }

  const { code: savedCode, expireAt } = doc.data();

  if (savedCode !== code) {
    throw new functions.https.HttpsError("permission-denied", "Kod geçersiz.");
  }

  if (Date.now() > expireAt) {
    throw new functions.https.HttpsError("deadline-exceeded", "Kodun süresi dolmuş.");
  }

  // Kod doğruysa
  return { success: true };
});
