--灵子武者-刀圣
function c21520051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),4,4,21520045,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER))
--	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionCode,21520045),aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER))
--[[
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c21520051.fscondition)
	e0:SetOperation(c21520051.fsoperation)
	c:RegisterEffect(e0)--]]
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520051.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCondition(c21520051.spcon)
	e2:SetOperation(c21520051.spop)
	c:RegisterEffect(e2)
	--when special success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520051,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c21520051.geqtg)
	e3:SetOperation(c21520051.eqop)
--	e3:SetValue(c21520051.valcheck)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520051,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c21520051.eqtg)
	e4:SetOperation(c21520051.eqop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c21520051.desreptg)
	e5:SetOperation(c21520051.desrepop)
	c:RegisterEffect(e5)
end
--[[
function c21520051.fscondition(e,g,gc,chkf)
	if g==nil then return true end
	if gc then return false end
	local g1=g:Filter(Card.IsSetCard,nil,0x494)
	local g2=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local ag=g1:Clone()
	ag:Merge(g2)
	if chkf~=PLAYER_NONE and not ag:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return g1:GetCount()>=5 and g1:IsExists(Card.IsCode,1,nil,21520045) and g2:GetCount()>0 and ag:GetCount()>5
end
function c21520051.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	if gc then return end
	local g1=eg:Filter(Card.IsSetCard,nil,0x494)
	local g2=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local ag=g1:Clone()
	ag:Merge(g2)
	local mg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local fg1=ag:FilterSelect(tp,Card.IsCode,1,1,nil,21520045)
	ag:Sub(fg1)
	local fg2=ag:FilterSelect(tp,Card.IsSetCard,4,4,nil,0x494)
	ag:Sub(fg2)
	local fg3=ag:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	mg:Merge(fg1)
	mg:Merge(fg2)
	mg:Merge(fg3)
	Duel.SetFusionMaterial(mg)
end--]]
function c21520051.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c21520051.spfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsSetCard,5,nil,0x494) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,21520045)
end
function c21520051.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c21520051.spfilter,tp,LOCATION_MZONE,0,nil)
	return g and g:GetCount()>0
end
function c21520051.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21520051.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c21520051.geqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c21520051.geqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520051.geqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c21520051.geqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c21520051.geqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520051.valcheck(e)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520051.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown()
		or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Equip(tp,tc,c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c21520051.eqlimit)
	tc:RegisterEffect(e1)
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk)
	tc:RegisterEffect(e2)
	local def=tc:GetTextDefense()
	if def<0 then def=0 end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(def)
	tc:RegisterEffect(e3)
end
function c21520051.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
--	bc:CancelToGrave()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,bc,1,0,0)
end
function c21520051.eqlimit(e,c)
	return e:GetOwner()==c
end
function c21520051.repfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c21520051.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c21520051.repfilter,1,nil)
	end
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,c21520051.repfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	return true
end
function c21520051.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
--[[
function c21520051.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk,def=0,0
			if tc:IsFacedown() or tc:GetTextAttack()<0 then atk=0 
			else atk=tc:GetTextAttack() end
			if tc:IsFacedown() or tc:GetTextDefense()<0 then def=0 
			else def=tc:GetTextDefense() end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c21520051.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			e3:SetValue(def)
			tc:RegisterEffect(e3)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
--]]