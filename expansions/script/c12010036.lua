--靜儀式 鏡天城 
function c12010036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12010036,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,12010036)
	e4:SetCondition(c12010036.thcon)
	e4:SetTarget(c12010036.thtg)
	e4:SetOperation(c12010036.thop)
	c:RegisterEffect(e4)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12010036,1))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,12010036)
	e4:SetCondition(c12010036.recon)
	e4:SetTarget(c12010036.retg)
	e4:SetOperation(c12010036.reop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010036,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c12010036.drcon)
	e2:SetTarget(c12010036.drtg)
	e2:SetOperation(c12010036.drop)
	c:RegisterEffect(e2)
end
function c12010036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetLP(tp)>=Duel.GetLP(1-tp)
end
function c12010036.thfilter(c,lp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsAbleToHand()
end
function c12010036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local lp=math.abs(lp1-lp2)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12010036.thop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local lp=math.abs(lp1-lp2)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c12010036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lp) then return false end
	local g=Duel.SelectMatchingCard(tp,c12010036.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lp)
	local tc=g:GetFirst()
	if tc then 
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,tc)
			Duel.Damage(tp,tc:GetDefense(),REASON_EFFECT)
		end
	end
end
function c12010036.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c12010036.refilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsReleasable()
end
function c12010036.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,0,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c12010036.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c12010036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c12010036.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
		if Duel.Release(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,tc:GetBaseAttack()*2,REASON_EFFECT)
		end
	end
end
function c12010036.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c12010036.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12010036.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,2,REASON_EFFECT)
end
