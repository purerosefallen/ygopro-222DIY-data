--拒绝奉向悲伤的花与红伞
function c22261212.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(c22261212.retg)
    e2:SetOperation(c22261212.reop)
    c:RegisterEffect(e2)
end
c22261504.named_with_MayuAzaka=1
c22261504.Desc_Contain_MayuAzaka=1
function c22261504.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
--
function c22261504.refilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c22261504.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c22261504.refilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c22261504.refilter,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c22261504.refilter,tp,0,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end