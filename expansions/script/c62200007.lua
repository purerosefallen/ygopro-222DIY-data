--玻离之物 残象
local m=62200007
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_FragileArticles=true
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c62200007.matfilter,1,1)
    c:EnableReviveLimit()
    --RecoverI
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200007,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,622000071)
    e1:SetCondition(c62200007.con1)
    e1:SetTarget(c62200007.tg1)
    e1:SetOperation(c62200007.op1)
    c:RegisterEffect(e1)
    --RecoverII
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(62200007,0))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCountLimit(1,622000072)
    e2:SetCondition(c62200007.con2)
    e2:SetTarget(c62200007.tg2)
    e2:SetOperation(c62200007.op2)
    c:RegisterEffect(e2)    
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c62200007.mlimit)
    c:RegisterEffect(e10)
    local e11=e10:Clone()
    e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e11)
    local e12=e10:Clone()
    e12:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e12)
    local e13=e10:Clone()
    e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e13)
end
--
function c62200007.matfilter(c)
    return c:GetBaseAttack()==0
end
--
function c62200007.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c62200007.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:GetBaseAttack()==0
end
function c62200007.con1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c62200007.cfilter,1,nil,tp)
end
function c62200007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c62200007.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,1000,REASON_EFFECT)
end
--
function c62200007.con2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP)
end
function c62200007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1000)
end
function c62200007.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,1000,REASON_EFFECT)
    Duel.Recover(1-tp,1000,REASON_EFFECT)
end