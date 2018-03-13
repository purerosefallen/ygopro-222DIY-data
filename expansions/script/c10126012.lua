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
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c10126012.effop)
	local eid=c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(eid)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE+LOCATION_FZONE,0)
	c:RegisterEffect(e4)
	e3:SetLabel(eid)
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
function c10126012.efilter(c,eid)
	return c:IsHasEffect(eid) and c:IsSetCard(0x1335)
end
function c10126012.efilter2(c,fc)
	return bit.band(c:GetOriginalType(),TYPE_EFFECT)~=0 and c:IsFaceup() and (not c:IsRelateToCard(fc) or not fc:IsRelateToCard(c))
end
function c10126012.effop(e,tp,eg,ep,ev,re,r,rp)
	local c,eid=e:GetHandler(),e:GetLabel()
Debug.Message(eid)
	local g=Duel.GetMatchingGroup(c10126012.efilter,tp,LOCATION_MZONE,0,nil,eid)
	if g:GetCount()<=0 or not c:IsHasEffect(eid) then return end
	for tc in aux.Next(g) do
		local tg=tc:GetEquipGroup():Filter(c10126012.efilter2,nil,c)
		if tg:GetCount()>0 then
		   for ec in aux.Next(tg) do
			   local code=ec:GetOriginalCodeRule()
			   local cid=tc:CopyEffect(code,RESET_EVENT+0x7fe0000)
			   ec:CreateRelation(c,RESET_EVENT+0x5fe0000)
			   c:CreateRelation(ec,RESET_EVENT+0x7ff0000)
			   local e1=Effect.CreateEffect(tc)
			   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			   e1:SetCode(EVENT_ADJUST)
			   e1:SetOperation(c10126012.resetop)
			   e1:SetLabel(cid)
			   e1:SetValue(eid)
			   Duel.RegisterEffect(e1,tp)
			   local e2=Effect.CreateEffect(c)
			   e2:SetType(EFFECT_TYPE_FIELD)
			   e2:SetCode(10126012)
			   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			   e2:SetLabelObject(ec)
			   e2:SetTargetRange(1,1)
			   Duel.RegisterEffect(e2,tp)
			   e1:SetLabelObject(e2)
		   end
		end
	end
end
function c10126012.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tc,e2=e:GetOwner(),e:GetLabelObject()
	local c,ec=e2:GetOwner(),e2:GetLabelObject()
	local eid=e:GetValue()
	if not ec:IsRelateToCard(c) or not c:IsRelateToCard(ec) or not tc:IsHasEffect(eid) or not ec:GetEquipTarget() or ec:GetEquipTarget()~=tc or not c:IsHasEffect(eid) then
	   tc:ResetEffect(e:GetLabel(),RESET_COPY)
	   c:ReleaseRelation(ec)
	   ec:ReleaseRelation(c)
	   e2:Reset()
	   e:Reset()
	end
end
function c10126012.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10126012.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
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
function c10126012.cfilter(c,e,tp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	local tc=c:GetEquipTarget()
	return (c:IsSetCard(0x1335) or (tc and tc:IsControler(tp))) and ((Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) and Duel.GetMZoneCount(tp,c)>0) or Duel.IsExistingMatchingCard(c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_DECK,LOCATION_SZONE,1,c,tp)) 
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
		  (Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.IsExistingMatchingCard(c10126012.thfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_DECK,LOCATION_SZONE,1,nil,tp)
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
	local op,g=e:GetLabel(),nil
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