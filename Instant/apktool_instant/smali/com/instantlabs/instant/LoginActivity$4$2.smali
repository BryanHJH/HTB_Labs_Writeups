.class Lcom/instantlabs/instant/LoginActivity$4$2;
.super Ljava/lang/Object;
.source "LoginActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/instantlabs/instant/LoginActivity$4;->onResponse(Lokhttp3/Call;Lokhttp3/Response;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/instantlabs/instant/LoginActivity$4;


# direct methods
.method constructor <init>(Lcom/instantlabs/instant/LoginActivity$4;)V
    .locals 0

    iput-object p1, p0, Lcom/instantlabs/instant/LoginActivity$4$2;->this$1:Lcom/instantlabs/instant/LoginActivity$4;

    .line 113
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    iget-object v0, p0, Lcom/instantlabs/instant/LoginActivity$4$2;->this$1:Lcom/instantlabs/instant/LoginActivity$4;

    .line 116
    iget-object v0, v0, Lcom/instantlabs/instant/LoginActivity$4;->this$0:Lcom/instantlabs/instant/LoginActivity;

    const-string v1, "Invalid response format"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method
