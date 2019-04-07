--灵都·涅槃朝霭的传说
local m=1110151
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110151.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c1110151.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c1110151.con3)
	e3:SetOperation(c1110151.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1110151,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1110151)
	e4:SetCondition(c1110151.con4)
	e4:SetOperation(c1110151.op4)
	c:RegisterEffect(e4)
--
	if c1110151.checklp==nil then
		c1110151.checklp=true
		c1110151.lplist={[0]=Duel.GetLP(tp),[1]=Duel.GetLP(tp),}
	end
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c1110151.op6)
	c:RegisterEffect(e6)
	c1110151[e6]={}
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(1110151)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(1110152)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
--
end
--
function c1110151.val2(e,se,sp,st)
	local sc=se:GetHandler()
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and sc:IsCode(1111301)
end
--
function c1110151.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL 
end
--
function c1110151.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(tp,c1110151.lplist[tp])
end
--
function c1110151.con4(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
--
function c1110151.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	if mg:GetCount()<1 then return end
	local mc=mg:GetFirst()
	while mc do
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetLabelObject(re)
		e4_1:SetValue(c1110151.efilter4_1)
		e4_1:SetReset(RESET_PHASE+PHASE_END)
		mc:RegisterEffect(e4_1)
		mc=mg:GetNext()
	end
end
function c1110151.efilter4_1(e,te)
	local re=e:GetLabelObject()
	return te:IsActiveType(re:GetActiveType())
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--
--
function c1110151.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function c1110151.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(c1110151.gfilter2,1,nil,c:GetOriginalCode())
end
function c1110151.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function c1110151.copyfilter(c,ec)
	return c:IsFaceup() and ec:GetSummonType()==SUMMON_TYPE_RITUAL 
		and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER)
		and not c:IsHasEffect(1110151)
end
function c1110151.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()~=SUMMON_TYPE_RITUAL then return end
	local copyt=c1110151[e]
	local exg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c1110151.copyfilter,tp,0,LOCATION_MZONE,nil,ec)
	for tc,copy_id in pairs(copyt) do
		if tc and copy_id then exg:AddCard(tc) end
	end
	local dg=exg:Filter(c1110151.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(c1110151.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(c1110151.rcon(e:GetCondition(),tc,copyt))
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function c1110151.rcon(con,tc,copyt)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(1110152) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		if not con or con(e,tp,eg,ep,ev,re,r,rp) then return true end
		return e:IsHasType(0x7e0) and c:GetFlagEffect(m)>0
	end
end