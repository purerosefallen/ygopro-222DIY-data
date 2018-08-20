--星辉女神
local m=66915000
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(cm.eqtg)
    e2:SetOperation(cm.eqop)
    c:RegisterEffect(e2) 
    --atkup
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_SINGLE)
    e22:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCode(EFFECT_UPDATE_ATTACK)
    e22:SetValue(cm.val)
    c:RegisterEffect(e2)   
end
function cm.val(e,c)
    return c:GetEquipCount()*100
end
function cm.filter(c)
    return c:IsSetCard(0x374) and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,false) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(cm.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function cm.eqlimit(e,c)
    return e:GetOwner()==c
end