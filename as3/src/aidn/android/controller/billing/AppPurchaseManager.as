package aidn.android.controller.billing 
{
	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	import com.pozirk.payment.android.InAppSkuDetails;
	
	/** @eventType InAppPurchaseEvent.INIT_SUCCESS */
	[Event(name="INIT_SUCCESS",           type="com.pozirk.payment.android.InAppPurchaseEvent")]
	/** @eventType InAppPurchaseEvent.INIT_ERROR */
	[Event(name="INIT_ERROR",             type="com.pozirk.payment.android.InAppPurchaseEvent")]
	
	/** @eventType InAppPurchaseEvent.RESTORE_SUCCESS */
	[Event(name="RESTORE_SUCCESS",        type="com.pozirk.payment.android.InAppPurchaseEvent")]
	/** @eventType InAppPurchaseEvent.RESTORE_ERROR */
	[Event(name="RESTORE_ERROR",          type="com.pozirk.payment.android.InAppPurchaseEvent")]
	
	/** @eventType InAppPurchaseEvent.PURCHASE_SUCCESS */
	[Event(name="PURCHASE_SUCCESS",       type="com.pozirk.payment.android.InAppPurchaseEvent")]
	/** @eventType InAppPurchaseEvent.PURCHASE_ERROR */
	[Event(name="PURCHASE_ERROR",         type="com.pozirk.payment.android.InAppPurchaseEvent")]
	/** @eventType InAppPurchaseEvent.PURCHASE_ALREADY_OWNED */
	[Event(name="PURCHASE_ALREADY_OWNED", type="com.pozirk.payment.android.InAppPurchaseEvent")]
	
	/** @eventType InAppPurchaseEvent.CONSUME_SUCCESS */
	[Event(name="CONSUME_SUCCESS",        type="com.pozirk.payment.android.InAppPurchaseEvent")]
	/** @eventType InAppPurchaseEvent.CONSUME_ERROR */
	[Event(name="CONSUME_ERROR",          type="com.pozirk.payment.android.InAppPurchaseEvent")]
	
	
	public class AppPurchaseManager extends InAppPurchase
	{
		/// テスト用アイテムID (購入成功) 
		public static const TEST_PURCHASED_ID   :String = "android.test.purchased";
		/// テスト用アイテムID (購入処理中にエラー or 購入がキャンセル)
		public static const TEST_CANCELED_ID    :String = "android.test.canceled";
		/// テスト用アイテムID (払い戻し)
		public static const TEST_REFUNDED_ID    :String = "android.test.refunded";
		/// テスト用アイテムID (存在しないアイテムID)
		public static const TEST_UNAVALIABLE_ID :String = "android.test.item_unavaliable";
		
		
		/**
		 * 
		 * 必要なANE:
		 * https://github.com/pozirk/AndroidInAppPurchase
		 * 
		 * 購入テスト方法:
		 * http://devwalker.blogspot.jp/2013/07/google-play-in-app-billing.html
		 * http://engineer-arise.blogspot.jp/2013/06/v3.html
		 * 
		 * AndroidManifest.xml:
		 * <uses-permission android:name="com.android.vending.BILLING" />  
		 * 
		 */
		public function AppPurchaseManager ( ) 
		{
			super();
		}
		
		/**
		 * 初期化
		 * @param	base64EncodedPublicKey	ライセンスキー
		 */
		override public function init ( base64EncodedPublicKey :String ) :void 
		{
			super.init(base64EncodedPublicKey);
		}
		 
		/**
		 * 詳細情報を取得 (引数空: 購入済み一覧, 引数指定: 購入済みor未購入関わらず取得)
		 * @param	items		アイテムID 配列
		 * @param	subs		サブスクリプションID 配列 (サブスクリプション:月額や年額など定期課金)
		 */
		override public function restore ( items :Array = null, subs :Array = null ) :void 
		{
			super.restore(items, subs);
		}
		
		/**
		 * 購入処理
		 * @param	sku			アイテムID or サブスクリプションID
		 * @param	type		アイテム(InAppPurchaseDetails.TYPE_INAPP) or サブスクリプション(InAppPurchaseDetails.TYPE_SUBS)
		 * @param	payload
		 */
		override public function purchase ( sku :String, type :String, payload :String = null ) :void 
		{
			super.purchase(sku, type, payload);
		}
		
		/**
		 * 購入済みアイテムの消費処理
		 * @param	sku		アイテムID
		 */
		override public function consume ( sku :String ) :void 
		{
			super.consume(sku);
		}
		
		/**
		 * IDに紐付く詳細情報を取得(購入済み)
		 * @param	sku			アイテムID or サブスクリプションID
		 * @return
		 */
		override public function getPurchaseDetails ( sku :String ) :InAppPurchaseDetails 
		{
			return super.getPurchaseDetails(sku);
		}
		
		/**
		 * IDに紐付く詳細情報を取得
		 * @param	sku			アイテムID or サブスクリプションID
		 * @return
		 */
		override public function getSkuDetails ( sku :String ) :InAppSkuDetails 
		{
			return super.getSkuDetails(sku);
		}
	}
}