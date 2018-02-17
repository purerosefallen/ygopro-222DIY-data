--地狱屠夫 拉西克
function c10129004.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129004,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c10129004.thcon)
	e1:SetCost(c10129004.thcost)
	e1:SetTarget(c10129004.thtg)
	e1:SetOperation(c10129004.thop)
	c:RegisterEffect(e1)  
	--MoveSequence
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129004,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10129004.mscon)
	e2:SetTarget(c10129004.mstg)
	e2:SetOperation(c10129004.msop)
	c:RegisterEffect(e2)	
end
function c10129004.mscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_REMOVED) and r==REASON_FUSION 
end
function c10129004.cfilter2(c,tp)
	if not c:IsType(TYPE_FUSION) or c:IsControler(1-tp) then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function c10129004.mstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10129004.cfilter2,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
end
function c10129004.msop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=eg:GetFirst()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local cg=Duel.GetMatchingGroup(c10129004.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc:GetColumnGroup())
	if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10129004,2)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local dg=cg:Select(tp,1,1,nil)
	   Duel.HintSelection(dg)
	   Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end
end
function c10129004.thfilter(c,g)
	return g:IsContains(c) and c:IsAbleToHand()
end
function c10129004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION 
end
function c10129004.cfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_FUSION)
end
function c10129004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10129004.cfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=eg:FilterSelect(tp,c10129004.cfilter,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(g:GetFirst())
		e1:SetCountLimit(1)
		e1:SetOperation(c10129004.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10129004.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c10129004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10129004.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end