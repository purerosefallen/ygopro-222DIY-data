--直树美纪
function c75646022.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,75646022)
	e3:SetCost(c75646022.cost)
	e3:SetTarget(c75646022.pentg)
	e3:SetOperation(c75646022.penop)
	c:RegisterEffect(e3) 
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,5646022)
	e2:SetTarget(c75646022.drtg)
	e2:SetOperation(c75646022.drop)
	c:RegisterEffect(e2)
end
function c75646022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c75646022.penfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsType(0x1000000) and not c:IsCode(75646022) and not c:IsForbidden()
end
function c75646022.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
		and Duel.IsExistingMatchingCard(c75646022.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c75646022.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c75646022.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if Duel.SelectYesNo(tp,aux.Stringid(75646020,0)) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c75646022.thfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsAbleToHand() and not c:IsCode(75646022)
end
function c75646022.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646022.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75646022.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646022.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end