--梅蒂欣·梅兰可莉
local m=1140001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Medicine=true
--
function c1140001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1140001,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1140001.tg1)
	e1:SetOperation(c1140001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1140001,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCost(c1140001.cost2)
	e2:SetTarget(c1140001.tg2)
	e2:SetOperation(c1140001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1140001.tfilter1(c,tp)
	return c:IsCode(1140121) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c1140001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1140001.tfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
--
function c1140001.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1140001,0))
	local tg=Duel.SelectMatchingCard(tp,c1140001.tfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	te:UseCountLimit(tp,1,true)
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
end
--
function c1140001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1140001.tfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_TRAP) and muxu.check_set_Poison(c) and c:IsAbleToGraveAsCost() then
		if c:CheckActivateEffect(false,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
--
function c1140001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c1140001.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1140001.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c1140001.tfilter2(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
--
function c1140001.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
