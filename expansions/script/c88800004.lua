--Domain of the Dragonlords
local card = c88800004
local id=88800004
function card.initial_effect(c)
      --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c88800004.activate)
    c:RegisterEffect(e1)
    --Change ATK 
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88800004,0))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfb0))
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetValue(300)
    c:RegisterEffect(e2)
    --Change DEF
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --Recover Monster
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
    e4:SetDescription(aux.Stringid(88800004,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_RELEASE)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,id)
    e4:SetCondition(card.thcon)
    e4:SetTarget(card.thtg)
    e4:SetOperation(card.thop)
    c:RegisterEffect(e4)
end

function card.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb0) and c:IsAbleToHand()
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(card.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88800004,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function card.thfilter1(c,tp)
    return c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function card.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(card.thfilter1,1,nil,tp)
end
function card.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(card.thfilter1,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function card.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local rg=g:Select(tp,1,1,nil)
    if rg:GetCount()>0 then
        Duel.SendtoHand(rg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,rg)
    end
end