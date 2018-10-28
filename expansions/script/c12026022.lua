--碧眼下的虚假 拉结尔
function c12026022.initial_effect(c)
	--Change effect to nothing
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026022,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,12026022)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12026022.condition)
	e1:SetTarget(c12026022.target)
	e1:SetOperation(c12026022.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026022,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12026022+100)
	e2:SetLabel(0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c12026022.destg)
	e2:SetOperation(c12026022.desop)
	c:RegisterEffect(e2)
end
function c12026022.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x1fbd)
end
function c12026022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local tg=re:GetTarget()
		local event=re:GetCode()
		if event==EVENT_CHAINING then return
		   not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else		 
		   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
		   return not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
		end
		return re:GetHandler():IsRelateToEffect(re) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local event=re:GetCode()
	e:SetLabelObject(re)
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	local tg=re:GetTarget()
	if event==EVENT_CHAINING then
	   if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	else
	   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	   if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12026022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOriginalCode()==12026022 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c12026022.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0x1fbd) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12026022,2))
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,nil,0x1fbd)
	local ct=Duel.GetCurrentChain()
	if ct>2 then 
	   e:SetLabel(1)
	   local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	   if tg:GetCount()>0 then
		local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetDescription(aux.Stringid(12026022,3))
		e12:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e12:SetCode(EFFECT_IMMUNE_EFFECT)
		e12:SetRange(LOCATION_ONFIELD)
		e12:SetReset(RESET_EVENT+0x1fe0000)
		e12:SetValue(c12026022.efilter)
		tg:GetFirst():RegisterEffect(e12)
	   end
	 end
end
function c12026022.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetDescription(aux.Stringid(12026022,3))
		e12:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e12:SetCode(EFFECT_IMMUNE_EFFECT)
		e12:SetRange(LOCATION_ONFIELD)
		e12:SetReset(RESET_EVENT+0x1fe0000)
		e12:SetValue(c12026022.efilter)
		tg:GetFirst():RegisterEffect(e12)
	end
end
function c12026022.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end