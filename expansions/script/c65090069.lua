--天邪逆鬼的本气
function c65090069.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65090069.con)
	e1:SetTarget(c65090069.tg)
	e1:SetOperation(c65090069.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65090069)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65090069.thtg)
	e2:SetOperation(c65090069.thop)
	c:RegisterEffect(e2)
end
function c65090069.filter(c)
	return c:IsOnField() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65090069.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:GetActivateLocation()==LOCATION_HAND and rc:IsControler(tp) and rc:IsSetCard(0x9da7) and rc:IsType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
end
function c65090069.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and re:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,re:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65090069.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and not re:GetHandler():IsLocation(LOCATION_DECK) then
		Duel.SpecialSummon(re:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c65090069.thfil(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65090069.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c65090069.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65090069.thfil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65090069.thfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65090069.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end