--传灵 月问
function c22600104.initial_effect(c)
     --spirit return
    aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    
    --changeposition
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600104)
    e2:SetCost(c22600104.cpcost)
    e2:SetCondition(c22600104.cpcon)
    e2:SetTarget(c22600104.cptg)
    e2:SetOperation(c22600104.cpop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1c0)
    e3:SetCondition(c22600104.con)
    c:RegisterEffect(e3)

    --specialsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,22600134)
    e4:SetCondition(c22600104.spcon)
    e4:SetTarget(c22600104.sptg)
    e4:SetOperation(c22600104.spop)
    c:RegisterEffect(e4)
end

function c22600104.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c22600104.cpfilter(c)
    return c:IsCanTurnSet() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c22600104.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
    local g2=Duel.GetMatchingGroup(c22600104.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,1,0,0)
end

function c22600104.cpop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600104.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local sg=g:Select(tp,1,1,nil)
        Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
    end
end
function c22600104.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function c22600104.cpcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22600104.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22600104.con(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c22600104.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c22600104.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
    and re:GetHandler()==e:GetHandler())
end

function c22600104.filter(c)
    return c:IsType(TYPE_SPIRIT)
end

function c22600104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600104.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c22600104.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600104.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(tp,c22600104.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetOperation(c22600104.retop)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        tc:GetFirst():RegisterEffect(e1,true)
    end
end
function c22600104.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end