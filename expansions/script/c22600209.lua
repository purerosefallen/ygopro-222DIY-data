--占星少女  薇格儿
function c22600209.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,22600209)
    e1:SetCost(c22600209.cost)
    e1:SetTarget(c22600209.target)
    e1:SetOperation(c22600209.operation)
    c:RegisterEffect(e1)

    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,22600210)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c22600209.sptg)
    e2:SetOperation(c22600209.spop)
    c:RegisterEffect(e2)
end

function c22600209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_COST)
end

function c22600209.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x262)
end

function c22600209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22600209.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c22600209.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c22600209.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c22600209.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(c22600209.efilter)
        e1:SetOwnerPlayer(tp)
        tc:RegisterEffect(e1)
    end
end

function c22600209.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

function c22600209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c22600209.spop(e,tp,eg,ep,ev,re,r,rp)
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

