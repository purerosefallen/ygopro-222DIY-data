--传灵 火尾
function c22600101.initial_effect(c)
     --spirit return
    aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600101)
    e2:SetCost(c22600101.descost)
    e2:SetCondition(c22600101.descon)
    e2:SetTarget(c22600101.destg)
    e2:SetOperation(c22600101.desop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1c0)
    e3:SetCondition(c22600101.con)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,22600131)
    e4:SetCondition(c22600101.dgcon)
    e4:SetOperation(c22600101.dgop)
    c:RegisterEffect(e4)
end

function c22600101.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c22600101.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
    local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end

function c22600101.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end
function c22600101.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function c22600101.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22600101.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22600101.con(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c22600101.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c22600101.dgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
    and re:GetHandler()==e:GetHandler())
end

function c22600101.filter(c)
    return c:IsSetCard(0x261) and c:IsType(TYPE_MONSTER)
end

function c22600101.dgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c22600101.filter,tp,LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end