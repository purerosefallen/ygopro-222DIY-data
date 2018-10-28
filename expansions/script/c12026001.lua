local m=12026001
local cm=_G["c"..m]
--黑白的神托
function c12026001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c12026001.activate)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026001,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c12026001.effcon)
	e2:SetTarget(c12026001.imtg)
	e2:SetOperation(c12026001.imop)
	e2:SetLabel(RACE_FAIRY)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(12026001,2))
	e3:SetTarget(c12026001.thtg)
	e3:SetOperation(c12026001.thop)
	e3:SetLabel(RACE_WINDBEAST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(12026001,3))
	e4:SetTarget(c12026001.imtg)
	e4:SetOperation(c12026001.drop)
	e4:SetLabel(RACE_MACHINE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(12026001,4))
	e5:SetTarget(c12026001.xyztg)
	e5:SetOperation(c12026001.xyzop)
	e5:SetLabel(RACE_WARRIOR)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetDescription(aux.Stringid(12026001,5))
	e6:SetTarget(c12026001.rmtg)
	e6:SetOperation(c12026001.rmop)
	e6:SetLabel(RACE_SEASERPENT)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_MATERIAL_CHECK)
	e7:SetValue(c12026001.valcheck)
	c:RegisterEffect(e7)  
end
c12026001.lighting_with_Raphael=1
function c12026001.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function c12026001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function c12026001.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	local ct=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g1:Select(tp,1,ct,nil)
	local ct3=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	if ct3<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g2:Select(tp,ct3,ct3,nil)   
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
end
function c12026001.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if not tc:IsRelateToEffect(e) then return end
	local fid=e:GetHandler():GetFieldID()
	tc:RegisterFlagEffect(12026001,RESET_EVENT+RESET_OVERLAY+RESET_TOFIELD,0,1,fid)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(tc)
	e2:SetLabel(tp)
	e2:SetValue(fid)
	e2:SetCondition(c12026001.drcon2)
	e2:SetOperation(c12026001.drop2)
	Duel.RegisterEffect(e2,tp)
end
function c12026001.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return false end
	if tc:GetFlagEffectLabel(12026001)~=e:GetValue() then e:Reset() return false end
	return true
end
function c12026001.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12026001)
	Duel.Draw(e:GetLabel(),1,REASON_EFFECT)
	e:Reset()
end
function c12026001.xyzfilter(c,e,tp,xyzc)
	return c:IsSetCard(0xfba) and xyzc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c12026001.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c12026001.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12026001.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12026001.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c12026001.thfilter2(c)
	return c:IsSetCard(0x2fb3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c12026001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12026001.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12026001.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12026001.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12026001.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsRace(e:GetLabel()) and eg:GetFirst():GetFlagEffect(12026001)~=0 and not eg:GetFirst():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c12026001.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c12026001.imop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c12026001.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x2fbd) or c:IsSetCard(0x1fbd)) and c:IsAbleToHand()
end
function c12026001.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c12026001.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12026001,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c12026001.matfilter(c)
	return (c:IsSetCard(0x2fbd) or c:IsSetCard(0x1fbd) or c:IsSetCard(0xfbb) or c:IsSetCard(0x1fb3)) and c:IsType(TYPE_MONSTER)
end
function c12026001.valcheck(e,c)
	if not c:GetMaterial():IsExists(c12026001.matfilter,1,nil) then return end
	c:RegisterFlagEffect(12026001,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
end