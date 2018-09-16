--Aeonbreaker Ambush
function c32904934.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c32904934.condition)
    e1:SetTarget(c32904934.target)
    e1:SetOperation(c32904934.operation)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c32904934.thtg)
    e2:SetOperation(c32904934.thop)
    c:RegisterEffect(e2)
    if not c32904934.global_check then
        c32904934.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_LEAVE_FIELD)
        ge1:SetCondition(c32904934.regcon)
        ge1:SetOperation(c32904934.regop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c32904934.cfilter(c)
    return c:IsPreviousSetCard(0xaa12) and c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousPosition(POS_FACEUP)
end
function c32904934.regcon(e,tp,eg,ep,ev,re,r,rp)
    local v=0
    if eg:IsExists(c32904934.cfilter,1,nil,0) then v=v+1 end
    if eg:IsExists(c32904934.cfilter,1,nil,1) then v=v+2 end
    if v==0 then return false end
    e:SetLabel(({0,1,PLAYER_ALL})[v])
    return true
end
function c32904934.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseEvent(eg,EVENT_CUSTOM+32904934,re,r,rp,ep,e:GetLabel())
end
function c32904934.cfilter1(c)
    return c:IsPreviousSetCard(0xaa12) and c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousPosition(POS_FACEUP)
end
function c32904934.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32904934.cfilter1,1,nil)
end
function c32904934.filter(c,e,tp)
    return c:IsSetCard(0xaa12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32904934.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c32904934.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32904934.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c32904934.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c32904934.thfilter(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32904934.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32904934.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c32904934.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32904934.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end