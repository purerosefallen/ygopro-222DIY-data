--霸业皇者
function c21520088.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21520088.fsfilter,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21520088.sprcon)
	e0:SetOperation(c21520088.sprop)
	c:RegisterEffect(e0)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetValue(c21520088.splimit)
	c:RegisterEffect(e01)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c21520088.indescon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1_2)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
--	e2:SetCountLimit(3)
	e2:SetCost(c21520088.cost)
	e2:SetTarget(c21520088.tg)
	e2:SetOperation(c21520088.op)
	c:RegisterEffect(e2)
end
function c21520088.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520088.fsfilter(c)
	return (c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) and c:IsCanBeFusionMaterial()
end
function c21520088.spfilter(c)
	return c21520088.fsfilter and c:IsAbleToDeckOrExtraAsCost()
end
function c21520088.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c21520088.fselect,1,sg,tp,mg,sg)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function c21520088.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520088.spfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520088.fselect,1,nil,tp,mg,sg)
end
function c21520088.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520088.spfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c21520088.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c21520088.indescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c21520088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	e:GetHandler():RegisterFlagEffect(21520088,RESET_CHAIN,0,1)
	tc:RegisterFlagEffect(21520088,RESET_CHAIN,0,1,e:GetHandler():GetFlagEffect(21520088))
	if tc:IsType(TYPE_MONSTER) then 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520088,0))
		if tc:IsAttribute(ATTRIBUTE_EARTH) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1010)
		elseif tc:IsAttribute(ATTRIBUTE_WATER) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1011)
		elseif tc:IsAttribute(ATTRIBUTE_FIRE) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1012)
		elseif tc:IsAttribute(ATTRIBUTE_WIND) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1013)
		elseif tc:IsAttribute(ATTRIBUTE_LIGHT) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1014)
		elseif tc:IsAttribute(ATTRIBUTE_DARK) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1015)
		elseif tc:IsAttribute(ATTRIBUTE_DEVINE) then 
			Duel.Hint(HINT_OPSELECTED,1-tp,1016)
		end
	elseif tc:IsType(TYPE_SPELL) then 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520088,1))
	elseif tc:IsType(TYPE_TRAP) then 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520088,2))
	end
end
function c21520088.disfilter(c,ct)
	return c:GetFlagEffectLabel(21520088)==ct
end
function c21520088.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21520088.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(21520088)
	local tc=Duel.GetMatchingGroup(c21520088.disfilter,tp,0xff,0xff,nil,ct):GetFirst()
	c:ResetFlagEffect(21520088) 
	ct=ct-1
	while ct>0 do
		c:RegisterFlagEffect(21520088,RESET_CHAIN,0,1)
		ct=ct-1
	end
	if c:IsRelateToEffect(e) then
		if tc:IsType(TYPE_MONSTER) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
--			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetTargetRange(0xff,0xff)
			e1:SetLabel(tc:GetAttribute())
			e1:SetTarget(c21520088.distgm)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(tc:GetAttribute())
			e2:SetOperation(c21520088.disopm)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		elseif tc:IsType(TYPE_SPELL) then 
			--disable
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e1:SetLabel(TYPE_SPELL)
			e1:SetTarget(c21520088.distgst)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--disable effect
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(TYPE_SPELL)
			e2:SetOperation(c21520088.disoperation)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			--disable trap monster
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetLabel(TYPE_SPELL)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c21520088.distgst)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		elseif tc:IsType(TYPE_TRAP) then 
			--disable
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e1:SetLabel(TYPE_TRAP)
			e1:SetTarget(c21520088.distgst)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--disable effect
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(TYPE_TRAP)
			e2:SetOperation(c21520088.disoperation)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			--disable trap monster
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetLabel(TYPE_TRAP)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c21520088.distgst)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c21520088.distgm(e,c)
	return c~=e:GetHandler() and c:IsAttribute(e:GetLabel()) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
		and not c:IsImmuneToEffect(e)
end
function c21520088.distgst(e,c)
	return c:IsType(e:GetLabel()) and not c:IsImmuneToEffect(e)
end
function c21520088.disopm(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(e:GetLabel()) and re:GetHandler()~=e:GetHandler() and not re:GetHandler():IsImmuneToEffect(e) then
		Duel.NegateEffect(ev)
	end
end
function c21520088.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
