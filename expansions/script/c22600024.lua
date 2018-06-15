--音语—二重奏之吉他×2
function c22600024.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,c22600018.spcheck)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22600024,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c22600024.rmcon)
    e1:SetTarget(c22600024.rmtg)
    e1:SetOperation(c22600024.rmop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22600024,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1c0)
    e2:SetCountLimit(1,22600024)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
    e2:SetTarget(c22600024.retg)
    e2:SetOperation(c22600024.reop)
    c:RegisterEffect(e2)
end
function c22600024.spcheck(g)
    return g:GetClassCount(Card.GetLevel)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLinkRace)==1
end
function c22600024.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22600024.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c22600024.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
        if g:GetCount()==0 then return end
        local rg=g:RandomSelect(tp,1)
        local tc=rg:GetFirst()
        Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
        tc:RegisterFlagEffect(22600024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(tc)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCondition(c22600024.retcon)
        e1:SetOperation(c22600024.retop)
        Duel.RegisterEffect(e1,tp)
end
function c22600024.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetFlagEffect(22600024)~=0
end
function c22600024.retop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
function c22600024.refilter1(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x260)
end
function c22600024.refilter2(c)
    return c:IsType(TYPE_MONSTER)
end
function c22600024.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c22600024.refilter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c22600024.refilter2,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectTarget(tp,c22600024.refilter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectTarget(tp,c22600024.refilter2,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function c22600024.reop(e,tp,eg,ep,ev,re,r,rp)
    local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
    local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
    local dc=dg:GetFirst()
    local cc=cg:GetFirst()
    if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e) then
        Duel.SendtoGrave(dc,REASON_EFFECT)
        Duel.Remove(cc,POS_FACEDOWN,REASON_EFFECT)
    end
end
