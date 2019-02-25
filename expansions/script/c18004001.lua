--性感手枪1号
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18004001
local cm=_G["c"..m]
if not rsv.SexGun then
	rsv.SexGun={} 
	rssg=rsv.SexGun
function rssg.IsSexGun(c)
	return c:CheckSetCard("SexGun")
end 
function rssg.SexGunCode(c)
	local e1=rsef.SV_CHANGE(c,"code",m+4)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
end
function rssg.SexGunSummonEffect(c,code)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,code},"th,se,tg,td","de",nil,nil,rssg.sexgunthtg,rssg.sexgunthop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,code},"th,se,tg,td","de",nil,nil,rssg.sexgunthtg,rssg.sexgunthop)
end 
function rssg.sexgunfilter(c)
	return c:CheckSetCard("SexGun") and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function rssg.sexgunthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(rssg.sexgunfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function rssg.sexgunthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectMatchingCard(tp,rssg.sexgunfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #hg>0 then
			Duel.ConfirmCards(1-tp,hg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if #tg<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if #tg2>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(tg2,nil,0,REASON_EFFECT)
		end
	end
end

end

if cm then
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	rssg.SexGunCode(c)   
	rssg.SexGunSummonEffect(c,m)
end
end