--神匠阵法 匠魂阵
function c10126012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	  
	--choose effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126012,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10126012.cecost)
	e2:SetTarget(c10126012.cetg)
	e2:SetOperation(c10126012.ceop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c10126012.effop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(10126012)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE+LOCATION_FZONE,0)
	c:RegisterEffect(e4)
	--cannot set/activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c10126012.setlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetValue(c10126012.actlimit)
	c:RegisterEffect(e6)
end
function c10126012.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10126012.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10126012.efilter(c,e)
	local cg=c:GetEquipGroup()
	return c:IsFaceup() and c:IsSetCard(0x1335) and cg and cg:IsExists(c10126012.efilter2,1,nil) and c:IsHasEffect(10126012) --and c:GetFlagEffect(10126012)==0
end
function c10126012.efilter2(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_EFFECT)~=0 and c:GetFlagEffect(10126012)<=0
end
function c10126012.effop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g,code=Duel.GetMatchingGroup(c10126012.efilter,tp,LOCATION_MZONE,0,nil),0
	--local ct=Duel.GetMatchingGroupCount(c10126012.efilter3,tp,LOCATION_MZONE,0,nil,10126112)
	--for i=1,ct do
		for tc in aux.Next(g) do
			--tc:RegisterFlagEffect(10126012,RESET_EVENT+0x1fe0000,0,1)
			local cg=tc:GetEquipGroup():Filter(c10126012.efilter2,nil)
			for ec in aux.Next(cg) do
				ec:RegisterFlagEffect(10126012,RESET_EVENT+0x1fe0000,0,1)
				code=ec:GetOriginalCodeRule()
				local cid=tc:CopyEffect(code,RESET_EVENT+0x1fe0000)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_ADJUST)
				e1:SetOperation(c10126012.resetop)
				e1:SetLabel(cid)
				e1:SetOwnerPlayer(tp)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(10126012)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,1)
				Duel.RegisterEffect(e2,tp)
				e1:SetLabelObject(e2)
				e2:SetLabelObject(ec)
			end
		end
	--end
end
function c10126012.resetop(e,tp,eg,ep,ev,re,r,rp)
	local fe,c,rtp=e:GetLabelObject(),e:GetOwner(),e:GetOwnerPlayer()
	local tc,ec=fe:GetOwner(),fe:GetLabelObject()
	local tc2=ec:GetEquipTarget()
	if not tc2 or tc2~=tc or ec:GetFlagEffect(10126012)<=0 or not tc:IsHasEffect(10126012) or tc:GetControler()~=rtp or not c:IsHasEffect(10126012) then 
	   tc:ResetEffect(e:GetLabel(),RESET_COPY) 
	   ec:ResetFlagEffect(10126012)
	   e:Reset()
	   fe:Reset()
	   --Duel.Readjust()
	end
end
function c10126012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c10126012.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10126012.thfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10126012.thfilter,tp,LOCATION_GRAVE+LOCATION_SZONE+LOCATION_DECK,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10126012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c10126012.cfilter(c,e,tp,sp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	local tc=c:GetEquipTarget()
	return (c:IsSetCard(0x1335) or (tc and tc:IsControler(tp))) and ((Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) and (c:IsLocation(LOCATION_MZONE) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) or Duel.IsExistingMatchingCard(c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE,1,c,tp)) 
end
function c10126012.thfilter(c,tp)
	if not c:IsAbleToHand() then return false end
	local ec=c:GetEquipTarget()
	return (c:IsSetCard(0x1335) and c:IsLocation(LOCATION_GRAVE+LOCATION_DECK)) or (ec and ec:IsControler(tp))
end
function c10126012.spfilter(c,e,tp)
	return c:IsSetCard(0x1335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126012.cecost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10126012.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()==1 then
		  e:SetLabel(0)
		  return Duel.IsExistingMatchingCard(c10126012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_SZONE,1,e:GetHandler(),e,tp)
	   else return
		  (Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.IsExistingMatchingCard(c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE,1,nil,tp)
	   end
	end
	if e:GetLabel()==1 then
	   e:SetLabel(0)
	   local g=Duel.SelectMatchingCard(tp,c10126012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_SZONE,1,1,e:GetHandler(),e,tp)
	   Duel.Release(g,REASON_COST)
	end
	local b1=(Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=Duel.IsExistingMatchingCard(c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_DECK,LOCATION_SZONE,1,nil,tp)
	local op=0
	if b1 and b2 then
	   op=Duel.SelectOption(tp,aux.Stringid(10126012,0),aux.Stringid(10126012,1))
	elseif b1 then
	   op=Duel.SelectOption(tp,aux.Stringid(10126012,0))
	else
	   op=Duel.SelectOption(tp,aux.Stringid(10126012,1))+1
	end
	e:SetLabel(op)
	if op==0 then
	   e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
	   e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE+LOCATION_SZONE+LOCATION_DECK)
	end
end
function c10126012.ceop(e,tp,eg,ep,ev,re,r,rp)
	local op,g=e:GetLabel()
	if op==0 then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   g=Duel.SelectMatchingCard(tp,c10126012.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	   end
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   g=Duel.SelectMatchingCard(tp,c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_DECK,LOCATION_SZONE,1,1,nil,tp)
	   if g:GetCount()>0 then
		  Duel.SendtoHand(g,tp,REASON_EFFECT)
	   end  
	end 
end