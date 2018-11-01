local m=12007040
local cm=_G["c"..m]
--兔姬，欢迎回家
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1)
    c:EnableReviveLimit()
    --equip
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,0))
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetRange(LOCATION_MZONE)
    e0:SetTarget(cm.eqtg)
    e0:SetOperation(cm.eqop)
    c:RegisterEffect(e0)
    --unequip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTarget(cm.target)
    e2:SetValue(cm.efilter)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(cm.eftg)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function cm.matfilter(c)
    return c:IsSetCard(0xfb2) and not c:IsCode(m)
end
function cm.eqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xfb2) and c:IsType(TYPE_MONSTER)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc) end
    if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown()) then return end
    if not tc:IsRelateToEffect(e) or not cm.eqfilter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,true) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(cm.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end
function cm.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.target(e,c)
    local c=e:GetHandler()
    local g,te=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
    return not (te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))
        or not (g and g:IsContains(c)) and c:IsSetCard(0xfb2)
end
function cm.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.eftg(e,c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb2)
end