--反骨的狂士 勇
function c10126004.initial_effect(c)
	--summon with 2 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126004,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10126004.otcon)
	e1:SetOperation(c10126004.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126004,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c10126004.eqtg)
	e3:SetOperation(c10126004.eqop)
	c:RegisterEffect(e3)
	--special summon equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126004,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c10126004.spcon)
	e4:SetTarget(c10126004.sptg)
	e4:SetOperation(c10126004.spop)
	c:RegisterEffect(e4)
end
function c10126004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10126004.spfilter(c,e,tp)
	return c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c10126004.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10126004.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10126004.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10126004.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local g=Duel.GetMatchingGroup(c10126004.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tc:GetCode())
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10126004,3)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		  local rg=g:Select(tp,1,1,nil)
		  Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	   end
	end
end
function c10126004.rmfilter(c,code)
	return c:IsAbleToRemove() and c:IsCode(code) and c:IsFaceup()
end
function c10126004.otfilter(c,tp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	if c:IsLocation(LOCATION_SZONE) then return c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp)
	else return c:IsSetCard(0x1335)
	end
end
function c10126004.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10126004.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,2,c,tp)
end
function c10126004.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c10126004.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,2,2,c,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c10126004.eqfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x1335) and c:GetBattleTarget():IsControler(1-tp) 
end
function c10126004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac,bc,tc=Duel.GetAttacker(),Duel.GetAttackTarget()
	if chk==0 then 
	   return bc~=nil and (c10126004.eqfilter(ac,tp) or c10126004.eqfilter(bc,tp)) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	end
	if c10126004.eqfilter(ac,tp) then tc=bc
	else tc=ac
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc:GetBattleTarget(),1,1-tp,LOCATION_MZONE)
end
function c10126004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(1-tp,tc,c,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10126003.eqlimit)
			tc:RegisterEffect(e1)
		else Duel.SendtoGrave(tc,REASON_EFFECT) 
		end
	end
end
function c10126004.eqlimit(e,c)
	return e:GetOwner()==c
end