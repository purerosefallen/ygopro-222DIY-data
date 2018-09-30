--事龙人 龙龙龙龙
function c12018004.initial_effect(c)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1fbe),LOCATION_MZONE)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,12018000,12018001,12018002,12018003,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12018004.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c12018004.spcon)
	e2:SetOperation(c12018004.spop)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_RACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(RACE_WYRM+RACE_SEASERPENT+RACE_DINOSAUR)
	c:RegisterEffect(e3)
	--asd asd asd asd asd asd asdasd asd asd 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c12018004.imtg)
	e4:SetOperation(c12018004.imop)
	c:RegisterEffect(e4)
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12018004.descon)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c12018004.target)
	e6:SetOperation(c12018004.activate)
	c:RegisterEffect(e6)
end
function c12018004.target(e,tp,eg,ep,ev,re,r,rp,chk)
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
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,re:GetHandler(),1,0,0)
end
function c12018004.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if re:GetHandler():IsRelateToEffect(re) then
	   Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function c12018004.ccfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018004.descon(e)
	return Duel.IsExistingMatchingCard(c12018004.ccfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c12018004.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12018004.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c12018004.imop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12018004.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoGrave(g,nil,REASON_EFFECT)
	   if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
			e2:SetValue(c12018004.efilter)
			e2:SetOwnerPlayer(tp)
			c:RegisterEffect(e2) 
	   end
	end
end
function c12018004.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function c12018004.efilter(e,re)
	return not re:GetHandler():IsSetCard(0xa656)
end
function c12018004.tgfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018004.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c12018004.cfilter(c)
	return c:IsFusionCode(12018000,12018001,12018002,12018003) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c12018004.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c12018004.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c12018004.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<4 then
		res=mg:IsExists(c12018004.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c12018004.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c12018004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c12018004.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c12018004.fselect,1,nil,tp,mg,sg,12018000,12018001,12018002,12018003)
end
function c12018004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c12018004.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c12018004.fselect,1,1,sg,tp,mg,sg,12018000,12018001,12018002,12018003)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end