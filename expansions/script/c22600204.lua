--占星少女  杰米娜
function c22600204.initial_effect(c)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22600204,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,22600204)
    e1:SetCost(c22600204.cost)
    e1:SetTarget(c22600204.target1)
    e1:SetOperation(c22600204.operation1)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22600204,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600204)
    e2:SetCost(c22600204.cost)
    e2:SetTarget(c22600204.target2)
    e2:SetOperation(c22600204.operation2)
    c:RegisterEffect(e2)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,22600205)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c22600204.sptg)
    e3:SetOperation(c22600204.spop)
    c:RegisterEffect(e3)
end

function c22600204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c22600204.filter1(c)
    return c:IsAbleToRemove()
end

function c22600204.filter2(c)
    return c:IsAbleToHand()
end

function c22600204.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600204.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c22600204.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c22600204.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c22600204.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)
        g:GetFirst():RegisterFlagEffect(22600204,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(g:GetFirst())
        e1:SetCountLimit(1)
        e1:SetCondition(c22600204.retcon)
        e1:SetOperation(c22600204.retop)
        Duel.RegisterEffect(e1,tp)
    end
end

function c22600204.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetFlagEffect(22600204)~=0
end

function c22600204.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end

function c22600204.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600204.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c22600204.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c22600204.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c22600204.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end

function c22600204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c22600204.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x262) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.DisableShuffleCheck()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    else
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
    end
end
