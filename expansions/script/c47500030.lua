--空域图
function c47500030.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500030,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,47500030)
    e1:SetCost(c47500030.cost)
    e1:SetTarget(c47500030.thtg)
    e1:SetOperation(c47500030.thop)
    c:RegisterEffect(e1)
    --inactivatable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetValue(c47500030.effectfilter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetValue(c47500030.effectfilter)
    c:RegisterEffect(e5)
end
c47500030.card_code_list={47500000}
function c47500030.costfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsReleasable()
end
function c47500030.thfilter(c)
    return aux.IsCodeListed(c,47500000) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))
end
function c47500030.thfilter2(c)
    return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x5da) or c:IsSetCard(0x5d0) or c:IsSetCard(0x5de))
end
function c47500030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47500030.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c47500030.thfilter2,tp,LOCATION_DECK,0,1,nil)end
    local g=Duel.SelectMatchingCard(tp,c47500030.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    Duel.Release(tc,REASON_COST)
    if tc:GetOriginalCode()==47500000 then
        e:SetLabel(1)
    end
end
function c47500030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500030.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c47500030.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500030,3))
    local g=Duel.SelectMatchingCard(tp,c47500030.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc and not tc:IsType(TYPE_CONTINUOUS) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
    if tc and tc:IsType(TYPE_CONTINUOUS) then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
    end
    if e:GetLabel()==1 then
        local g=Duel.SelectMatchingCard(tp,c47500030.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c47500030.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    return p==tp and aux.IsCodeListed(te:GetHandler(),47500000) and te:IsActiveType(TYPE_MONSTER)
end