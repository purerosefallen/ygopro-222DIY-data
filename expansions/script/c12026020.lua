--被选中的人 拉结尔
function c12026020.initial_effect(c)
	--Change effect to nothing
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026020,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12026020.descon)
	e1:SetTarget(c12026020.target)
	e1:SetOperation(c12026020.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026020,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetTarget(c12026020.rmtg)
	e2:SetOperation(c12026020.rmop)
	c:RegisterEffect(e2)
end
function c12026020.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND
end
function c12026020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg=re:GetTarget()
		local event=re:GetCode()
		if event==EVENT_CHAINING then return
		   not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else		 
		   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
		   return not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
		end
		return re:GetHandler():IsRelateToEffect(re)
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
end
function c12026020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOriginalCode()==12026020 then return end
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if c:IsLocation(LOCATION_ONFIELD) then
			local code=re:GetHandler():GetOriginalCode()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetValue(code)
				c:RegisterEffect(e1)
				c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	end
end
function c12026020.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local ccode=c:GetCode()
	local gcode=g:GetFirst():GetCode()
	   if ccode==gcode then 
			e:SetLabel(1) 
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	   else e:SetLabel(0) end
end
function c12026020.filter(c,e,tp)
	return c:IsSetCard(0x1fbd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12026020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		  Duel.Destroy(tc,REASON_EFFECT)
	end 
	if e:GetLabel()==1 and Duel.IsExistingTarget(c12026020.filter,tp,LOCATION_DECK,0,1,c,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(12026020,2)) then 
				local g=Duel.SelectMatchingCard(tp,c12026020.filter,tp,LOCATION_DECK,0,1,1,c,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end