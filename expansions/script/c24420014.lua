--Servant-源頼光
function c24420014.initial_effect(c)
		c:EnableReviveLimit()
	--return to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24420014,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c24420014.thtg)
	e1:SetOperation(c24420014.thop)
	c:RegisterEffect(e1)
    --position
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(24420014,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetTarget(c24420014.postg)
    e3:SetOperation(c24420014.posop)
    c:RegisterEffect(e3)	
	
end

function c24420014.thfilter(c)
	return c:IsCode(24420002) and c:IsAbleToHand()
end
function c24420014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24420014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420014.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24420014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c24420014.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    local d=Duel.GetAttackTarget()
    if chk==0 then return d and d:IsControler(1-tp) and d:IsRace(RACE_ZOMBIE+RACE_FIEND+RACE_FAIRY)  end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c24420014.posop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d:IsRelateToBattle() then
        Duel.Destroy(d,REASON_EFFECT)
    end
end

