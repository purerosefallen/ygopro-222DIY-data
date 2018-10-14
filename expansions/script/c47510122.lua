--暗夜的星晶兽 纳哈特
local m=47510122
local cm=_G["c"..m]
function c47510122.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c47510122.lcheck)
    c:EnableReviveLimit() 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510122,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47510122)
    e1:SetTarget(c47510122.sptg)
    e1:SetOperation(c47510122.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510122,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47510122.pocon)
    e2:SetOperation(c47510122.poop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetCondition(c47510122.indcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end
function c47510122.lcheck(g)
    return g:IsExists(Card.IsLinkType,1,nil,TYPE_FLIP)
end
function c47510122.tgfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_FIEND)) and c:IsAbleToGrave()
end
function c47510122.filter(c,tp)
    return c:IsType(TYPE_FLIP) and c:IsAbleToGrave()
        and Duel.IsExistingMatchingCard(c47510122.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c47510122.spfilter(c,e,tp)
    return c:IsType(TYPE_FLIP) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c47510122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47510122.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47510122.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47510122.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
        Duel.ConfirmCards(1-tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g1=Duel.SelectMatchingCard(tp,c47510122.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g1:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SendtoGrave(g1,REASON_EFFECT)
        end
    end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510122.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510122.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510122.pofilter(c)
    return c:IsFacedown()
end
function c47510122.pocon(e,tp,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return lg:IsExists(c47510122.pofilter,1,nil,lg)
end
function c47510122.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsFacedown,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,lg,lg:GetCount(),0,0)
end
function c47510122.poop(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsFacedown,nil)
    if Duel.ChangePosition(lg,POS_FACEUP_ATTACK) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c47510122.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
        Duel.BreakEffect()
        Duel.SendtoGrave(g,REASON_EFFECT)
    end   
end
function c47510122.indfilter(c)
    return (c:IsFacedown() or c:IsType(TYPE_FLIP)) and c:IsType(TYPE_MONSTER)
end
function c47510122.indcon(e,tp,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return lg:IsExists(c47510122.indfilter,1,nil,lg)
end
