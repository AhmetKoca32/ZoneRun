import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

admin.initializeApp();

/**
 * Google Play Purchase Receipt Validation
 *
 * Request Body:
 * {
 *   "userId": "user_id",
 *   "productId": "character_1",
 *   "purchaseToken": "google_play_purchase_token",
 *   "packageName": "com.example.zone_run"
 * }
 */
export const validateGooglePlayPurchase = functions.https.onCall(
  async (data, context) => {
    // Authentication kontrolü
    if (!context?.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const {productId, purchaseToken, packageName} = data as {
      productId: string;
      purchaseToken: string;
      packageName: string;
    };
    const userId = context.auth.uid;

    if (!productId || !purchaseToken || !packageName) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required fields"
      );
    }

    try {
      // Google Play API ile receipt validation
      // TODO: Service account key ile Google Play API'ye bağlan
      // Şimdilik basit validation
      const isValid = await validateGooglePlayReceipt(
        packageName,
        productId,
        purchaseToken
      );

      if (!isValid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid purchase receipt"
        );
      }

      // Firestore'a purchase kaydet
      const purchaseData = {
        userId,
        productId,
        purchaseToken,
        platform: "android",
        purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
        validated: true,
      };

      await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("purchases")
        .doc(purchaseToken)
        .set(purchaseData);

      // Character ID'yi extract et (productId: "character_1" -> 1)
      const characterId = extractCharacterId(productId);
      if (characterId) {
        // Purchased characters listesine ekle
        await addPurchasedCharacter(userId, characterId);
      }

      return {success: true, characterId};
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      functions.logger.error("Purchase validation error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Purchase validation failed",
        errorMessage
      );
    }
  }
);

/**
 * App Store Purchase Receipt Validation
 *
 * Request Body:
 * {
 *   "userId": "user_id",
 *   "productId": "character_1",
 *   "receiptData": "app_store_receipt_base64",
 *   "transactionId": "transaction_id"
 * }
 */
export const validateAppStorePurchase = functions.https.onCall(
  async (data, context) => {
    // Authentication kontrolü
    if (!context?.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const {productId, receiptData, transactionId} = data as {
      productId: string;
      receiptData: string;
      transactionId: string;
    };
    const userId = context.auth.uid;

    if (!productId || !receiptData || !transactionId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required fields"
      );
    }

    try {
      // App Store API ile receipt validation
      // TODO: App Store Server API ile doğrulama
      const isValid = await validateAppStoreReceipt(receiptData);

      if (!isValid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid purchase receipt"
        );
      }

      // Firestore'a purchase kaydet
      const purchaseData = {
        userId,
        productId,
        transactionId,
        platform: "ios",
        purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
        validated: true,
      };

      await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("purchases")
        .doc(transactionId)
        .set(purchaseData);

      // Character ID'yi extract et
      const characterId = extractCharacterId(productId);
      if (characterId) {
        await addPurchasedCharacter(userId, characterId);
      }

      return {success: true, characterId};
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      functions.logger.error("Purchase validation error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Purchase validation failed",
        errorMessage
      );
    }
  }
);

// ==================== Helper Functions ====================

/**
 * Google Play receipt validation
 * TODO: Google Play Developer API ile gerçek validation
 * @param {string} packageName - Package name
 * @param {string} productId - Product ID
 * @param {string} purchaseToken - Purchase token
 * @return {Promise<boolean>} Validation result
 */
async function validateGooglePlayReceipt(
  packageName: string,
  productId: string,
  purchaseToken: string
): Promise<boolean> {
  // TODO: Google Play Developer API kullan
  // Şimdilik basit kontrol
  return purchaseToken.length > 0;
}

/**
 * App Store receipt validation
 * TODO: App Store Server API ile gerçek validation
 * @param {string} receiptData - Receipt data
 * @return {Promise<boolean>} Validation result
 */
async function validateAppStoreReceipt(
  receiptData: string
): Promise<boolean> {
  // TODO: App Store Server API kullan
  // Şimdilik basit kontrol
  return receiptData.length > 0;
}

/**
 * Product ID'den character ID extract et
 * "character_1" -> 1
 * @param {string} productId - Product ID
 * @return {number|null} Character ID or null
 */
function extractCharacterId(productId: string): number | null {
  if (productId.startsWith("character_")) {
    const id = parseInt(productId.replace("character_", ""));
    return isNaN(id) ? null : id;
  }
  return null;
}

/**
 * Firestore'a purchased character ekle
 * @param {string} userId - User ID
 * @param {number} characterId - Character ID
 * @return {Promise<void>}
 */
async function addPurchasedCharacter(
  userId: string,
  characterId: number
): Promise<void> {
  const userRef = admin.firestore().collection("users").doc(userId);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    throw new Error("User not found");
  }

  const currentPurchased = userDoc.data()?.purchasedCharacters || [];
  if (!currentPurchased.includes(characterId)) {
    await userRef.update({
      purchasedCharacters: admin.firestore.FieldValue.arrayUnion(characterId),
    });
  }
}
