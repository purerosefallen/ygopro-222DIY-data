--新生的妖怪兔·优昙华院
function c1145002.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c1145002.LinkCondition(c1145002.Link,min,max,gf))
	e0:SetTarget(c1145002.LinkTarget(c1145002.Link,min,max,gf))
	e0:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c1145002.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c1145002.con3)
	e3:SetOperation(c1145002.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c1145002.val4)
	e4:SetCondition(c1145002.con4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetLabelObject(e3)
	e5:SetOperation(c1145002.op5)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c1145002.tg6)
	e6:SetCost(c1145002.cost6)
	e6:SetOperation(c1145002.op6)
	c:RegisterEffect(e6)
--
end
--
function c1145002.Link(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function c1145002.LExRabbitFilter(c,f,lc)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x132) or c:IsCode(11200019)) and c:IsCanBeLinkMaterial(lc)
end
function c1145002.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(c1145002.LExRabbitFilter,tp,LOCATION_HAND,0,f,lc)
	local mg3=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function c1145002.LinkCondition(f,min,max,gf)
	return
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=c1145002.GetLinkMaterials(tp,f,c)
		local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(Auxiliary.LCheckGoal,min,max,tp,c,gf)
	end
end
function c1145002.LinkTarget(f,min,max,gf)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=c1145002.GetLinkMaterials(tp,f,c)
		local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.GetCurrentChain()==0
		local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,min,max,tp,c,gf)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
--
function c1145002.val2(e,se,sp,st)
	return st==SUMMON_TYPE_LINK
		or e:GetHandler():GetFlagEffect(1145002)>0
end
--
function c1145002.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_LINK 
end
--
function c1145002.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(1145002,RESET_EVENT+0x0400000,0,0)
	local lg=c:GetMaterial()
	if lg and lg:GetCount()>0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	end
end
--
function c1145002.val4(e)
	local c=e:GetHandler()
	return c:GetMaterial():GetFirst():GetOriginalCode()
end
--
function c1145002.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMaterialCount()==1
end
--
function c1145002.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_LINK) then return end
	local lg=e:GetLabelObject():GetLabelObject()
	if not lg then return end
	if lg:GetCount()<1 then return end
	local tc=lg:GetFirst()
	while tc do
		if tc:IsType(TYPE_EFFECT) and not tc:IsType(TYPE_TRAPMONSTER) then
			c:CreateEffectRelation(e)
			local code=tc:GetOriginalCode()
			c1145002.CopyEffectExtraCount(c,15,code,0x1fe0000,1)
			c:ReleaseEffectRelation(e)
		end
		tc=lg:GetNext()
	end
end
function c1145002.CopyEffectExtraCount(c,ct,code,res,rct)
	local et={}
	local ef=Effect.SetCountLimit
	local ref=Card.RegisterEffect
	Effect.SetCountLimit=c1145002.replace_set_count_limit(et)
	Card.RegisterEffect=c1145002.replace_register_effect(et,ct,ef,ref)
	c:RegisterFlagEffect(1145003,res,0,rct,ct)
	local cid=c:CopyEffect(code,res,rct)
	Effect.SetCountLimit=ef
	Card.RegisterEffect=ref
	c:ResetFlagEffect(1145003)
	return cid
end
function c1145002.replace_set_count_limit(et)
	return
	function(e,ct,cd)
		et[e]={ct,cd}
	end
end
function c1145002.replace_register_effect(et,ct,ef,ref)
	return
	function(c,e,forced)
		local t=et[e]   
		if t then
			if e:IsHasType(0x7e0) then
				t[1]=math.max(t[1],ct)
			end
			ef(e,table.unpack(t))
		end
		ref(c,e,forced)
	end
end
--
function c1145002.tg6(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
--
function c1145002.cost6(e,te_or_c,tp)
	return e:GetHandler():IsReleasable()
end
--
function c1145002.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end
--
