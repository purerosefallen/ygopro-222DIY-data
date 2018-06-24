--你已经疯了！
function c11200023.initial_effect(c)
--
	c:SetUniqueOnField(1,1,11200023)
	c:EnableReviveLimit()
	c11200023.AddFusionProcFunRep(c,c11200023.mfilter,3,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11200023.con2)
	e2:SetOperation(c11200023.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200023,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c11200023.con3)
	e3:SetTarget(c11200023.tg3)
	e3:SetOperation(c11200023.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11200023,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c11200023.con4)
	e4:SetTarget(c11200023.tg4)
	e4:SetOperation(c11200023.op4)
	c:RegisterEffect(e4)
--
end
--
function c11200023.mfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
--
function c11200023.cfilter2_1(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c)>0 and 
		c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c11200023.cfilter2_2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,2,c,tp)
end
function c11200023.cfilter2_2(c,tp)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11200023.con2(e,c)
	if c==nil then return true end
	local p=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c11200023.cfilter2_1,p,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,p)
end
--
function c11200023.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local sg1=Duel.SelectMatchingCard(tp,c11200023.cfilter2_1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	local sc1=sg1:GetFirst()
	local sg2=Duel.SelectMatchingCard(tp,c11200023.cfilter2_2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,2,2,sc1,tp)
	sg2:AddCard(sc1)
	Duel.Remove(sg2,POS_FACEUP,REASON_COST)
end
--
function c11200023.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetMaterial()
	return c:GetFlagEffect(11200023)<1
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and rp~=tp
end
--
function c11200023.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200023.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 then
		Duel.Damage(1-tp,dc*200,REASON_EFFECT)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3_2:SetValue(1)
		e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3_2)
		local e3_3=e3_2:Clone()
		e3_3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e3_3)
	elseif dc==4 or dc==5 then
		Duel.Damage(1-tp,dc*200,REASON_EFFECT)
		local e3_5=Effect.CreateEffect(c)
		e3_5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3_5:SetType(EFFECT_TYPE_SINGLE)
		e3_5:SetRange(LOCATION_MZONE)
		e3_5:SetCode(EFFECT_IMMUNE_EFFECT)
		e3_5:SetValue(c1150035.efilter3_5)
		e3_5:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		c:RegisterEffect(e3_5)
	elseif dc>5 then
		Duel.Damage(1-tp,dc*400,REASON_EFFECT)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3_2:SetValue(1)
		e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3_2)
		local e3_3=e3_2:Clone()
		e3_3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e3_3)
		local e3_5=Effect.CreateEffect(c)
		e3_5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3_5:SetType(EFFECT_TYPE_SINGLE)
		e3_5:SetRange(LOCATION_MZONE)
		e3_5:SetCode(EFFECT_IMMUNE_EFFECT)
		e3_5:SetValue(c1150035.efilter3_5)
		e3_5:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		c:RegisterEffect(e3_5)
	else
	end
end
--
function c11200023.efilter3_5(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c11200023.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetMaterial()
	return c:GetFlagEffect(11200023)>0
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and rp~=tp
end
--
function c11200023.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200023.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1:SetCode(EFFECT_UPDATE_ATTACK)
	e3_1:SetValue(dc*200)
	e3_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_1)
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3_2:SetType(EFFECT_TYPE_SINGLE)
	e3_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3_2:SetValue(1)
	e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3_2)
	local e3_3=e3_2:Clone()
	e3_3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e3_3)
	local e3_4=Effect.CreateEffect(c)
	e3_4:SetType(EFFECT_TYPE_SINGLE)
	e3_4:SetCode(EFFECT_UPDATE_ATTACK)
	e3_4:SetValue(dc*200)
	e3_4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_4)
	local e3_5=Effect.CreateEffect(c)
	e3_5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3_5:SetType(EFFECT_TYPE_SINGLE)
	e3_5:SetRange(LOCATION_MZONE)
	e3_5:SetCode(EFFECT_IMMUNE_EFFECT)
	e3_5:SetValue(c1150035.efilter3_5)
	e3_5:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	c:RegisterEffect(e3_5)
end
--
function c11200023.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	c11200023.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--
function c11200023.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			table.insert(mat,val[i])
		end
	end
	if #mat>0 and c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.material_count=#mat
		mt.material=mat
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(aux.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(c11200023.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
--
function c11200023.FOperationMix(insf,sub,...)
	local funs={...}
	return  
	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local chkf=chkfnf&0xff
		local c=e:GetHandler()
		local tp=c:GetControler()
		local notfusion=chkfnf>>8~=0
		local sub=sub or notfusion
		local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
		local sg=Group.CreateGroup()
		if gc then sg:AddCard(gc) end
		while sg:GetCount()<#funs do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g=mg:FilterSelect(tp,Auxiliary.FSelectMix,1,1,sg,tp,mg,sg,c,sub,chkf,table.unpack(funs))
			sg:Merge(g)
		end
		Duel.SetFusionMaterial(sg)
		if sg:IsExists(Card.IsCode,1,nil,11200019) and sg:IsExists(Card.IsCode,1,nil,11200065) then
			c:RegisterFlagEffect(11200023,RESET_EVENT+0xfe0000,0,0)
		end
	end
end
--